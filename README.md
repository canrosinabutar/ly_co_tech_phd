👉 HOW TO RUN THE CHATOPS LAB:

   1. Start the Mac Host Server (Terminal 1):
      cd ghost-protocol-v5
      npx ts-node src/kernel/ghost-kernel.ts

   2. Build the Docker Image (Terminal 2):
      cd ghost-protocol-v5
      docker build -t ghost-chatops .

   3. ⚡ FIRE THE CHAT TERMINAL (Terminal 2):
      docker run -it --rm ghost-chatops
      (⚠️ Make sure to use the '-it' flag so you can type!)