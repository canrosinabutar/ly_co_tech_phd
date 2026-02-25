import * as net from 'net';
import * as readline from 'readline';
import { GHOST_CONFIG } from '../shared/config';

const client = new net.Socket();
let startTime = 0;

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    prompt: '👻 GHOST-Chat: '
});

console.clear();
console.log(`===============================================`);
console.log(`🤖 GHOST DUAL-COMMANDER (V5 MULTI-PLATFORM)`);
console.log(`===============================================`);
console.log(`Usage: <platform> <action> <payload>`);
console.log(`Example:`);
console.log(`- android input hello`);
console.log(`- ios input tudelft.nl`);
console.log(`- android tap 500 500`);
console.log(`===============================================\n`);

client.connect(GHOST_CONFIG.TCP_PORT, GHOST_CONFIG.DEFAULT_HOST, () => {
    console.log(`[🔗] Connected to Dual-Kernel Mac.\n`);
    rl.prompt(); 
});

rl.on('line', (line) => {
    const input = line.trim().toLowerCase();
    const parts = input.split(' ');
    const platform = parts[0]; // android atau ios

    if (!['android', 'ios'].includes(platform)) {
        console.log(`[❌] Start with 'android' or 'ios'`);
        rl.prompt(); return;
    }

    const action = parts[1]?.toUpperCase();
    const payload = parts.slice(2).join(' ');

    startTime = Date.now();
    client.write(`CHAT:${platform.toUpperCase()}:${action}:${payload}\n`);
});

client.on('data', (data) => {
    const [status, platform, time] = data.toString().trim().split('|');
    if (status === 'READY') {
        const latency = Date.now() - startTime;
        console.log(`\x1b[32m   [⚡ ${latency}ms] Confirmed on ${platform}!\x1b[0m\n`);
        rl.prompt(); 
    }
});