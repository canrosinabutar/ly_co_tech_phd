import * as net from 'net';
import { spawn, execSync } from 'child_process';
import { GHOST_CONFIG } from '../shared/config';

const clients: net.Socket[] = [];

console.log(`\n[👻 GHOST KERNEL SERVER] Booting up on Mac Host...`);
console.log(`[🚀 MODE] Dual-Observer (Monitoring IOS & ANDROID Simultaneously)`);

// --- 1. THE DUAL-OBSERVER ---

function startAndroidStream() {
    try { execSync('adb logcat -c'); } catch (e) {} // Bersihkan log lama
    const stream = spawn('adb', ['logcat', '-s', 'GHOST_TAG:D']);
    console.log(`[🔌 ANDROID HOOK] Monitoring Android Kernel...`);
    
    stream.stdout.on('data', (data: Buffer) => {
        if (data.toString().includes(GHOST_CONFIG.TRIGGER_PHRASE)) {
            broadcast('ANDROID');
        }
    });
}

function startIOSStream() {
    const stream = spawn('xcrun', ['simctl', 'spawn', 'booted', 'log', 'stream', '--predicate', `eventMessage contains "${GHOST_CONFIG.TRIGGER_PHRASE}"`]);
    console.log(`[🔌 IOS HOOK] Monitoring IOS Kernel...`);

    stream.stdout.on('data', (data: Buffer) => {
        const line = data.toString();
        if (line.includes(GHOST_CONFIG.TRIGGER_PHRASE) && !line.includes('Filtering')) {
            broadcast('IOS');
        }
    });
}

function broadcast(platform: string) {
    const timestamp = Date.now();
    clients.forEach(client => client.write(`READY|${platform}|${timestamp}\n`));
}

// Jalankan kedua telinga!
startAndroidStream();
startIOSStream();

// --- 2. THE CHAT EXECUTOR (TCP SERVER) ---

const server = net.createServer((socket) => {
    console.log(`\n[🔗 NEW CONNECTION] Chat Commander connected!`);
    clients.push(socket);

    socket.on('data', (data) => {
        const msg = data.toString().trim();
        if (msg.startsWith('CHAT:')) {
            const [_, platform, actionType, payload] = msg.split(':');
            console.log(`[🤖 COMMAND] Target: ${platform} | Action: ${actionType}`);

            if (platform === 'ANDROID') {
                if (actionType === 'INPUT') spawn('adb', ['shell', 'input', 'text', payload.replace(/ /g, '%s')]);
                else if (actionType === 'TAP') { const [x, y] = payload.split(' '); spawn('adb', ['shell', 'input', 'tap', x, y]); }
                else if (actionType === 'ENTER') spawn('adb', ['shell', 'input', 'keyevent', '66']);
                
                // Feedback signal for Android
                setTimeout(() => spawn('adb', ['shell', 'log', '-t', 'GHOST_TAG', '"GHOST_READY"']), 50);
            } 
            else if (platform === 'IOS') {
                // Untuk iOS kita gunakan openurl sebagai pemicu log
                spawn('xcrun', ['simctl', 'openurl', 'booted', `https://${payload || GHOST_CONFIG.TRIGGER_PHRASE}`]);
            }
        }
    });

    socket.on('end', () => clients.splice(clients.indexOf(socket), 1));
});

server.listen(GHOST_CONFIG.TCP_PORT, '0.0.0.0', () => {
    console.log(`[🚀 LISTENING] GHOST Dual-Receiver ready on port ${GHOST_CONFIG.TCP_PORT}...`);
});