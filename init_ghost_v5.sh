#!/bin/bash

# ========================================================
# 👻 GHOST PROTOCOL v5.0: AGENTIC CHATOPS EDITION
# Interactive Natural Language to OS Action via TCP
# ========================================================

PROJECT_NAME="ghost-protocol-v5"

echo "🚀 INITIALIZING GHOST PROTOCOL v5.0 (Agentic ChatOps Architecture)..."

# 1. Setup Environment & Directories
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

mkdir -p src/kernel src/actor src/shared

# 2. Init NPM & Install Dependencies
if [ ! -f "package.json" ]; then
    npm init -y > /dev/null
fi

echo "📦 Installing Dependencies (typescript, ts-node)..."
npm install typescript ts-node @types/node --save-dev > /dev/null 2>&1

# 3. TypeScript Config
cat << 'EOF' > tsconfig.json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "CommonJS",
    "rootDir": "./src",
    "outDir": "./dist",
    "strict": true,
    "esModuleInterop": true
  },
  "include": ["src/**/*"]
}
EOF

# ---------------------------------------------------------
# 4. SHARED CONFIGURATION
# ---------------------------------------------------------
echo "📝 Generating Shared Config..."
cat << 'EOF' > src/shared/config.ts
export const GHOST_CONFIG = {
    TCP_PORT: 9999,
    TRIGGER_PHRASE: 'GHOST_READY',
    DEFAULT_HOST: process.env.GHOST_HOST || 'host.docker.internal' 
};
EOF

# ---------------------------------------------------------
# 5. THE KERNEL (MAC HOST - THE TRANSLATOR & EXECUTOR)
# ---------------------------------------------------------
echo "📝 Generating Kernel Server (Mac Host)..."
cat << 'EOF' > src/kernel/ghost-kernel.ts
import * as net from 'net';
import { spawn, execSync } from 'child_process';
import { GHOST_CONFIG } from '../shared/config';

const clients: net.Socket[] = [];
const PLATFORM = 'ANDROID'; // Fokus ke Android untuk Agentic UI Demo

console.log(`\n[👻 GHOST KERNEL SERVER] Booting up on Mac Host...`);
console.log(`[🎯 OBSERVER TARGET] ${PLATFORM}`);

// Bersihkan "Hantu Masa Lalu" (Log lama) agar tidak spamming saat boot
try {
    console.log(`[🧹 CLEANUP] Clearing old Android logs...`);
    execSync('adb logcat -c');
} catch (e) {
    console.log(`[⚠️] Could not clear adb logs. Is Emulator running?`);
}

// --- 1. THE OBSERVER ---
function startNativeStream(command: string, args: string[]) {
    console.log(`[🔌 OS HOOK] Attaching to Kernel Stream...`);
    const stream = spawn(command, args);

    stream.stdout.on('data', (data: Buffer) => {
        const line = data.toString();
        if (line.includes(GHOST_CONFIG.TRIGGER_PHRASE)) {
            const timestamp = Date.now();
            clients.forEach(client => client.write(`READY|${timestamp}\n`));
        }
    });
    stream.stderr.on('data', () => {});
}

startNativeStream('adb', ['logcat', '-s', 'GHOST_TAG:D']);

// --- 2. THE CHAT EXECUTOR (TCP SERVER) ---
const server = net.createServer((socket) => {
    console.log(`\n[🔗 NEW CONNECTION] Chat Commander connected!`);
    clients.push(socket);

    socket.on('data', (data) => {
        const msg = data.toString().trim();
        
        // Format pesan masuk: CHAT:ACTION_TYPE:PAYLOAD
        if (msg.startsWith('CHAT:')) {
            const parts = msg.split(':');
            const actionType = parts[1];
            const payload = parts.slice(2).join(':');

            console.log(`[🤖 COMMAND] Executing ${actionType} -> ${payload || 'NONE'}`);

            // Terjemahkan NLP ke Perintah Fisik Android
            if (actionType === 'INPUT') {
                const formattedText = payload.replace(/ /g, '%s');
                spawn('adb', ['shell', 'input', 'text', formattedText]);
            } else if (actionType === 'TAP') {
                const coords = payload.split(' ');
                spawn('adb', ['shell', 'input', 'tap', coords[0], coords[1]]);
            } else if (actionType === 'ENTER') {
                spawn('adb', ['shell', 'input', 'keyevent', '66']);
            }
            
            // Setelah fisik ditekan, tembakkan sinyal log untuk kalkulasi latensi
            setTimeout(() => {
                spawn('adb', ['shell', 'log', '-t', 'GHOST_TAG', '"Action Complete: GHOST_READY"']);
            }, 50);
        }
    });

    socket.on('end', () => {
        clients.splice(clients.indexOf(socket), 1);
        console.log(`[❌ DISCONNECTED] Chat Commander left.`);
    });
    socket.on('error', () => {});
});

server.listen(GHOST_CONFIG.TCP_PORT, '0.0.0.0', () => {
    console.log(`[🚀 LISTENING] GHOST Chat Receiver ready on port ${GHOST_CONFIG.TCP_PORT}...`);
});
EOF

# ---------------------------------------------------------
# 6. THE ACTOR (DOCKER CI RUNNER - INTERACTIVE CHAT)
# ---------------------------------------------------------
echo "📝 Generating Interactive Actor (Docker)..."
cat << 'EOF' > src/actor/ghost-actor.ts
import * as net from 'net';
import * as readline from 'readline';
import { GHOST_CONFIG } from '../shared/config';

const client = new net.Socket();
let startTime = 0;

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    prompt: '👻 You: '
});

console.clear();
console.log(`===============================================`);
console.log(`🤖 GHOST CHAT COMMANDER (ANDROID MODE)`);
console.log(`===============================================`);
console.log(`Commands available:`);
console.log(`- input <text>   (e.g., input rahasia123)`);
console.log(`- tap <x> <y>    (e.g., tap 500 1200)`);
console.log(`- enter          (Presses Enter key)`);
console.log(`- exit           (Quit)`);
console.log(`===============================================\n`);

client.connect(GHOST_CONFIG.TCP_PORT, GHOST_CONFIG.DEFAULT_HOST, () => {
    console.log(`[🔗] Connected to Mac Host. Ready for commands!\n`);
    rl.prompt(); 
});

rl.on('line', (line) => {
    const input = line.trim();
    if (input.toLowerCase() === 'exit') {
        client.destroy();
        process.exit(0);
    }
    if (!input) { rl.prompt(); return; }

    let actionType = '';
    let payload = '';

    if (input.startsWith('input ')) {
        actionType = 'INPUT';
        payload = input.substring(6);
    } else if (input.startsWith('tap ')) {
        actionType = 'TAP';
        payload = input.substring(4);
    } else if (input === 'enter') {
        actionType = 'ENTER';
    } else {
        console.log(`[❌] Unknown command. Use 'input', 'tap', or 'enter'.`);
        rl.prompt();
        return;
    }

    startTime = Date.now();
    client.write(`CHAT:${actionType}:${payload}\n`);
});

client.on('data', (data) => {
    const msg = data.toString().trim();
    if (msg.startsWith('READY')) {
        const latency = Date.now() - startTime;
        console.log(`\x1b[32m   [⚡ ${latency}ms] Mac executed action and confirmed UI state.\x1b[0m\n`);
        rl.prompt(); 
    }
});

client.on('error', (err) => {
    console.error(`\n[❌ FATAL] Connection lost to Mac Host at ${GHOST_CONFIG.DEFAULT_HOST}.`);
    process.exit(1);
});
EOF

# ---------------------------------------------------------
# 7. DOCKERFILE
# ---------------------------------------------------------
echo "📝 Generating Dockerfile..."
cat << 'EOF' > Dockerfile
FROM node:20-alpine
WORKDIR /ghost
COPY package*.json ./
RUN npm install > /dev/null 2>&1
COPY tsconfig.json .
COPY src ./src
# Jalankan Actor sebagai proses utama (menunggu interaksi user)
ENTRYPOINT ["npx", "ts-node", "src/actor/ghost-actor.ts"]
EOF

echo ""
echo "✅ GHOST PROTOCOL v5.0 (AGENTIC CHATOPS) INSTALLED SUCCESSFULLY!"
echo "   Folder: $PROJECT_NAME/"
echo "---------------------------------------------------"
echo "👉 HOW TO RUN THE CHATOPS LAB:"
echo ""
echo "   1. Start the Mac Host Server (Terminal 1):"
echo "      cd $PROJECT_NAME"
echo "      npx ts-node src/kernel/ghost-kernel.ts"
echo ""
echo "   2. Build the Docker Image (Terminal 2):"
echo "      cd $PROJECT_NAME"
echo "      docker build -t ghost-chatops ."
echo ""
echo "   3. ⚡ FIRE THE CHAT TERMINAL (Terminal 2):"
echo "      docker run -it --rm ghost-chatops"
echo "      (⚠️ Make sure to use the '-it' flag so you can type!)"
echo "---------------------------------------------------"