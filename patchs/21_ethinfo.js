'use strict';
'require baseclass';
'require rpc';
'require network';
'require ui';

var callSwconfigFeatures = rpc.declare({
	object: 'luci',
	method: 'getSwconfigFeatures',
	params: ['switch'],
	expect: { '': {} }
});

var callSwconfigPortState = rpc.declare({
	object: 'luci',
	method: 'getSwconfigPortState',
	params: ['switch'],
	expect: { result: [] }
});

var callLuciBoardJSON = rpc.declare({
	object: 'luci-rpc',
	method: 'getBoardJSON',
	expect: { '': {} }
});

var callLuciNetworkDevices = rpc.declare({
	object: 'luci-rpc',
	method: 'getNetworkDevices',
	expect: { '': {} }
});

var isDSA = false;

const ethStyle = {
	box: 'width: 100%; padding: 5px; box-sizing: border-box;',
	card: `
		border: 1px solid #d3d3d3;
		border-radius: 8px;
		overflow: hidden;
		box-shadow: 0 2px 4px rgba(0,0,0,0.1);
		display: flex; flex-direction: column;
		background-color: #fff;
		min-width: 90px;
		height: 100%;
		`,
	head: `
		padding: 8px 5px;
		text-align: center;
		font-weight: bold;
		color: #333;
		font-size: 0.9rem;
		flex-shrink: 0;
		`,
	body: `
		padding: 10px 5px;
		display: flex; flex-direction: column;
		align-items: center;
		flex-grow: 1;
		justify-content: space-between;
		`,
	icon: 'margin-bottom: 8px; width: 40px; height: 40px;',
	speed: 'font-size: 0.9rem; font-weight: bold; color: #555; margin-bottom: 5px;',
	duplex: 'font-size: 0.8rem; color: #666; margin-bottom: 8px;',
	traffic: `
		width: 100%;
		text-align: center;
		padding-top: 8px;
		border-top: 1px solid #eee;
		font-size: 0.8rem;
		color: #555;
		flex-shrink: 0;
		`,
	trafficLine: 'display: flex; justify-content: space-between; padding: 1px 0;'
};

function formatSpeed(speed) {
	if (speed <= 0 || isNaN(parseInt(speed))) {
		return '-';
	}
	const speedInt = parseInt(speed);
	if (speedInt < 1000) {
		return `${speedInt} Mbps`;
	}
	return `${(speedInt / 1000).toFixed(1).replace(/\.0+$/, '')} Gbps`;
}

function getPortColor(carrier, duplex) {
	if (!carrier) {
		return 'background-color: #e0e0e0;';
	}
	if (duplex === 'full' || duplex === true) {
		return 'background-color: #a5d6a7;';
	}
	return 'background-color: #ffcc80';
}

function getPortIcon(carrier) {
	return L.resource(`icons/port_${carrier ? 'up' : 'down'}.png`);
}

function portDom(link, duplex, label, speed, tx_bytes, rx_bytes) {
	const portIcon = getPortIcon(link);
	const headColor = getPortColor(link, duplex);
    const txrx = { tx_bytes: tx_bytes || 0, rx_bytes: rx_bytes || 0 };

	return E('div', { style: ethStyle.box }, [
		E('div', { style: ethStyle.card }, [
			E('div', { style: ethStyle.head + headColor }, label),
			E('div', { style: ethStyle.body }, [
				E('img', { style: ethStyle.icon, src: portIcon }),
				E('div', { style: ethStyle.speed }, formatSpeed(speed)),
				E('div', { style: ethStyle.duplex }, link ? (duplex === 'full' || duplex === true ? _('Full Duplex') : _('Half Duplex')) : '-'),
				E('div', { style: ethStyle.traffic }, [
					E('div', { style: ethStyle.trafficLine }, [
						E('span', {}, '\u25b2 Tx:'),
						E('span', {}, '%1024.1mB'.format(txrx.tx_bytes))
					]),
					E('div', { style: ethStyle.trafficLine }, [
						E('span', {}, '\u25bc Rx:'),
						E('span', {}, '%1024.1mB'.format(txrx.rx_bytes))
					])
				])
			])
		])
	]);
}

return baseclass.extend({
	title: _('Ethernet Information'),

	load: function () {
		return network.getSwitchTopologies().then(function (topologies) {
			if (Object.keys(topologies).length === 0) {
				isDSA = true;
				return Promise.all([
					L.resolveDefault(callLuciBoardJSON(), {}),
					L.resolveDefault(callLuciNetworkDevices(), {})
				]);
			}

			if (topologies.switch0) {
				callSwconfigPortState('switch0').then((ports) => {
					if (topologies.switch0) {
						topologies.switch0.portstate = ports;
					}
				}).catch(e => {
					console.error("Failed to get swconfig port state:", e);
				});
			}

			return Promise.all([
				topologies,
				L.resolveDefault(callLuciBoardJSON(), {}),
				L.resolveDefault(callLuciNetworkDevices(), {})
			]);
		});
	},

	render_gsw: function (data) {
		const topologies = data[0];
		const board = data[1];
		const netdevs = data[2];

		let stats;
		let foundWAN = false;
		const ethPorts = [];
		const switch0 = topologies.switch0;
		const txrx_default = { tx_bytes: 0, rx_bytes: 0 };

		if (!switch0 || !Array.isArray(switch0.ports)) {
			return [E('div', {}, _('Swconfig data not available or incomplete.'))];
		}

		const wanDeviceName = board.network?.wan?.device;
		const wanStats = (wanDeviceName && netdevs[wanDeviceName]) ? netdevs[wanDeviceName].stats : txrx_default;

		const brLanStats = netdevs['br-lan'] ? netdevs['br-lan'].stats : txrx_default;

		for (const port of switch0.ports) {
			const label = (port.label || `Port ${port.num}`).toUpperCase();
			const portState = switch0.portstate ? switch0.portstate[port.num] : {};
			const { link, duplex, speed } = portState;

			let currentStats = txrx_default;

			if (label.startsWith('WAN')) {
				foundWAN = true;
				currentStats = wanStats;
				ethPorts.unshift(
					portDom(link, duplex, 'WAN', speed, currentStats.tx_bytes, currentStats.rx_bytes)
				);
			} else if (label.startsWith('LAN')) {
				currentStats = link ? brLanStats : txrx_default;
				ethPorts.push(portDom(link, duplex, label, speed, currentStats.tx_bytes, currentStats.rx_bytes));
			} else {

            }
		}

		if (!foundWAN && wanDeviceName && netdevs[wanDeviceName]) {
			const wanDev = netdevs[wanDeviceName];
			const { speed, duplex, carrier } = wanDev.link || {};
			const { tx_bytes, rx_bytes } = wanDev.stats || txrx_default;
			ethPorts.unshift(
				portDom(carrier, duplex, 'WAN', speed, tx_bytes, rx_bytes)
			);
		}

		return ethPorts;
	},

	render_dsa: function (data) {
		const board = data[0];
		const netdevs = data[1];

		const ethPorts = [];
        const txrx_default = { tx_bytes: 0, rx_bytes: 0 };

		const wanDeviceName = (board.network?.wan?.device) || '';
		let devices = `${wanDeviceName},lan0,lan1,lan2,lan3,lan4,lan5,lan6`;
		devices = devices.split(',').filter(d => d);

		for (const device of devices) {
			if (!(device in netdevs)) {
				continue;
			}

			const dev = netdevs[device];
			const { speed, duplex, carrier } = dev.link || {};
			const { tx_bytes, rx_bytes } = dev.stats || txrx_default;

			const label = (wanDeviceName && device === wanDeviceName) ? 'WAN' : dev.name.toUpperCase();

            ethPorts.push(portDom(carrier, duplex, label, speed, tx_bytes, rx_bytes));
		}

		return ethPorts;
	},

	render: function (data) {
		const ethPorts = isDSA ? this.render_dsa(data) : this.render_gsw(data);

		const gridStyle = `
			display: grid;
			grid-gap: 15px;
			grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
			margin: 0px auto 1em auto; 
			justify-items: center;
			max-width: 1000px;
			padding: 0 15px;
		`;

		if (!Array.isArray(ethPorts) || ethPorts.length === 0 || (ethPorts.length === 1 && ethPorts[0].tagName === 'DIV' && ethPorts[0].textContent.includes('data not available'))) {
            if (ethPorts && ethPorts.length === 1 && ethPorts[0].tagName === 'DIV') {
                return ethPorts[0];
            }
			return E('div', { class: 'cbi-section' }, [
				E('p', { class: 'cbi-section-node' }, _('No Ethernet ports found or network data unavailable.'))
			]);
		}

		return E('div', { style: gridStyle }, ethPorts);
	}
});
