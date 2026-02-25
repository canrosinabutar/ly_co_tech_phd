# Project Overview

This project, LY Co, Tech PHD, focuses on developing innovative solutions to enhance the user experience in various tech domains. It provides a comprehensive set of tools and functionalities aimed at improving efficiency and satisfaction.

# Features
- **User-Friendly Interface**: Easy navigation and access to various tools.
- **Customizable Settings**: Tailor the application to meet specific user needs.
- **Integration with Popular Tools**: Seamless connection with other applications to enhance functionality.

# Setup Instructions
1. **Clone the repository**:
   ```bash
   git clone https://github.com/canrosinabutar/ly_co_tech_phd.git
   cd ly_co_tech_phd
   ```
2. **Install Dependencies**:
   ```bash
   npm install
   ```
3. **Run the Application**:
   ```bash
   npm start
   ```
   **1. Start the Mac Host Server (Terminal 1):
   ```bash
   cd ghost-protocol-v5
   npx ts-node src/kernel/ghost-kernel.ts
   ```
   **2. Build the Docker Image (Terminal 2):
   ```bash
   cd ghost-protocol-v5
   docker build -t ghost-chatops .
   ```
   
   
# Usage Examples
- **Accessing Main Features**: Once the application is running, 
**⚡ FIRE THE CHAT TERMINAL (Terminal 2):
   ```bash
   docker run -it --rm ghost-chatops
   ```
   (⚠️ Make sure to use the '-it' flag so you can type!)
- **Customizing Settings**: Go to the Settings menu to customize your user preferences.
- **Integrating Tools**: Follow the integration guide in the documentation to connect with other applications.

For more information and advanced usage, please refer to the [documentation](https://github.com/canrosinabutar/ly_co_tech_phd/blob/main/docs/README.md).
