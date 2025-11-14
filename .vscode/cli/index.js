#!/usr/bin/env node

const readline = require('readline');
const fs = require('fs');
const path = require('path');
const os = require('os');
const axios = require('axios');
const chalk = require('chalk');

class OllamaAgent {
  constructor() {
    this.apiUrl = process.env.OLLAMA_API_URL || 'http://localhost:8080';
    this.model = process.env.OLLAMA_MODEL || 'codellama';
    this.models = [];
    this.conversations = [];
    this.currentDir = process.cwd();
    this.contextFiles = [];
    this.configDir = path.join(os.homedir(), '.ollama-cli');
    this.settingsFile = path.join(this.configDir, 'settings.json');
    this.historyFile = path.join(this.configDir, 'history.jsonl');
    this.geminiMdPath = path.join(this.currentDir, 'GEMINI.md');
    
    this.settings = {
      theme: 'dark',
      model: this.model,
      apiUrl: this.apiUrl,
      autoSave: true,
      maxContextLines: 10000
    };

    this.ensureConfigDir();
    this.loadSettings();
    this.loadModels();
  }

  ensureConfigDir() {
    if (!fs.existsSync(this.configDir)) {
      fs.mkdirSync(this.configDir, { recursive: true });
    }
  }

  loadSettings() {
    if (fs.existsSync(this.settingsFile)) {
      try {
        this.settings = JSON.parse(fs.readFileSync(this.settingsFile, 'utf-8'));
      } catch (e) {
        console.error('Error loading settings:', e.message);
      }
    }
  }

  saveSettings() {
    fs.writeFileSync(this.settingsFile, JSON.stringify(this.settings, null, 2));
  }

  async loadModels() {
    try {
      const res = await axios.get(`${this.apiUrl}/api/models`);
      this.models = res.data.models?.map(m => m.name) || ['codellama'];
    } catch (e) {
      this.models = ['codellama'];
    }
  }

  loadContextFromGeminiMd() {
    if (fs.existsSync(this.geminiMdPath)) {
      try {
        return fs.readFileSync(this.geminiMdPath, 'utf-8');
      } catch (e) {
        return '';
      }
    }
    return '';
  }

  async queryOllama(prompt, includeContext = true) {
    let fullPrompt = prompt;
    
    if (includeContext) {
      const geminiContext = this.loadContextFromGeminiMd();
      if (geminiContext) {
        fullPrompt = `Project Instructions:\n${geminiContext}\n\nUser Query:\n${prompt}`;
      }
    }

    try {
      const res = await axios.post(`${this.apiUrl}/api/chat`, {
        model: this.model,
        prompt: fullPrompt,
        system_prompt: 'You are a helpful AI assistant integrated into a CLI. Provide concise, practical responses.'
      });

      return res.data.response || '';
    } catch (error) {
      return `Error: ${error.message}`;
    }
  }

  printWelcome() {
    console.clear();
    console.log(chalk.cyan(`
    ╔═══════════════════════════════════════╗
    ║         🦙 Ollama CLI Agent          ║
    ║      (Gemini CLI Compatible)         ║
    ╚═══════════════════════════════════════╝
    `));
    console.log(chalk.gray(`Model: ${chalk.cyan(this.model)} | API: ${chalk.cyan(this.apiUrl)}`));
    console.log(chalk.gray(`Working Directory: ${chalk.cyan(this.currentDir)}`));
    console.log(chalk.dim('\nType /help for available commands\n'));
  }

  printHelp() {
    console.log(chalk.bold.cyan('\n📚 Available Commands:\n'));
    console.log(chalk.yellow('/help') + '               - Show this help menu');
    console.log(chalk.yellow('/model <name>') + '        - Switch to a different model');
    console.log(chalk.yellow('/models') + '             - List available models');
    console.log(chalk.yellow('/settings') + '           - Show current settings');
    console.log(chalk.yellow('/set <key> <val>') + '    - Update a setting');
    console.log(chalk.yellow('/file <path>') + '        - Analyze or load a file');
    console.log(chalk.yellow('/dir <path>') + '         - Add directory to context');
    console.log(chalk.yellow('/context') + '            - Show loaded context files');
    console.log(chalk.yellow('/clear') + '              - Clear conversation');
    console.log(chalk.yellow('/save <name>') + '        - Save current conversation');
    console.log(chalk.yellow('/load <name>') + '        - Load saved conversation');
    console.log(chalk.yellow('/history') + '            - Show conversation history');
    console.log(chalk.yellow('!<command>') + '          - Execute shell command');
    console.log(chalk.yellow('@<term>') + '             - Search web (with --web flag)');
    console.log(chalk.yellow('/exit') + '               - Exit the application\n');
  }

  printSettings() {
    console.log(chalk.bold.cyan('\n⚙️  Current Settings:\n'));
    Object.entries(this.settings).forEach(([key, val]) => {
      console.log(`  ${chalk.yellow(key)}: ${chalk.cyan(JSON.stringify(val))}`);
    });
    console.log();
  }

  async handleCommand(input) {
    const [cmd, ...args] = input.slice(1).split(' ');

    switch (cmd.toLowerCase()) {
      case 'help':
        this.printHelp();
        break;

      case 'model':
        if (args[0]) {
          if (this.models.includes(args[0])) {
            this.model = args[0];
            this.settings.model = this.model;
            this.saveSettings();
            console.log(chalk.green(`✓ Switched to model: ${chalk.cyan(this.model)}`));
          } else {
            console.log(chalk.red(`✗ Model not found: ${args[0]}`));
          }
        } else {
          console.log(chalk.yellow(`Current model: ${chalk.cyan(this.model)}`));
        }
        break;

      case 'models':
        console.log(chalk.bold.cyan('\n📦 Available Models:\n'));
        this.models.forEach(m => {
          const icon = m === this.model ? '✓' : ' ';
          console.log(`  ${chalk.cyan(icon)} ${m}`);
        });
        console.log();
        break;

      case 'settings':
        this.printSettings();
        break;

      case 'set':
        if (args.length >= 2) {
          const key = args[0];
          const val = args.slice(1).join(' ');
          this.settings[key] = isNaN(val) ? val : Number(val);
          this.saveSettings();
          console.log(chalk.green(`✓ Set ${chalk.yellow(key)} = ${chalk.cyan(val)}`));
        } else {
          console.log(chalk.red('Usage: /set <key> <value>'));
        }
        break;

      case 'file':
        if (args[0]) {
          await this.loadFile(args.join(' '));
        } else {
          console.log(chalk.red('Usage: /file <path>'));
        }
        break;

      case 'dir':
        if (args[0]) {
          this.addDirContext(args.join(' '));
        } else {
          console.log(chalk.red('Usage: /dir <path>'));
        }
        break;

      case 'context':
        this.showContext();
        break;

      case 'clear':
        this.conversations = [];
        console.log(chalk.green('✓ Conversation cleared'));
        break;

      case 'history':
        this.showHistory();
        break;

      case 'exit':
        console.log(chalk.cyan('Goodbye!'));
        process.exit(0);
        break;

      default:
        console.log(chalk.red(`Unknown command: /${cmd}`));
    }
  }

  async loadFile(filePath) {
    try {
      const fullPath = path.resolve(filePath);
      if (!fs.existsSync(fullPath)) {
        console.log(chalk.red(`✗ File not found: ${filePath}`));
        return;
      }

      const content = fs.readFileSync(fullPath, 'utf-8');
      this.contextFiles.push({ path: fullPath, content });
      console.log(chalk.green(`✓ Loaded: ${chalk.cyan(path.basename(fullPath))} (${content.length} chars)`));
    } catch (e) {
      console.log(chalk.red(`✗ Error loading file: ${e.message}`));
    }
  }

  addDirContext(dirPath) {
    try {
      const fullPath = path.resolve(dirPath);
      if (!fs.existsSync(fullPath)) {
        console.log(chalk.red(`✗ Directory not found: ${dirPath}`));
        return;
      }

      this.currentDir = fullPath;
      console.log(chalk.green(`✓ Changed context to: ${chalk.cyan(fullPath)}`));
    } catch (e) {
      console.log(chalk.red(`✗ Error: ${e.message}`));
    }
  }

  showContext() {
    console.log(chalk.bold.cyan('\n📂 Context Files:\n'));
    if (this.contextFiles.length === 0) {
      console.log(chalk.dim('  No files loaded'));
    } else {
      this.contextFiles.forEach((f, i) => {
        console.log(`  ${chalk.yellow(i + 1)}. ${chalk.cyan(f.path)}`);
      });
    }
    console.log();
  }

  showHistory() {
    console.log(chalk.bold.cyan('\n📜 Conversation History:\n'));
    if (this.conversations.length === 0) {
      console.log(chalk.dim('  No messages yet'));
    } else {
      this.conversations.slice(-10).forEach((msg, i) => {
        const role = msg.role === 'user' ? chalk.cyan('You') : chalk.green('AI');
        const text = msg.content.substring(0, 80).replace(/\n/g, ' ');
        console.log(`  ${chalk.dim(i + 1)}. ${role}: ${text}...`);
      });
    }
    console.log();
  }

  async handleUserInput(input) {
    if (input.startsWith('/')) {
      await this.handleCommand(input);
    } else if (input.startsWith('!')) {
      const { exec } = require('child_process');
      console.log(chalk.dim('\n$ ' + input.slice(1)));
      exec(input.slice(1), (error, stdout, stderr) => {
        if (error) {
          console.log(chalk.red(error.message));
        } else {
          console.log(stdout || stderr);
        }
        this.startRepl();
      });
    } else if (input.trim()) {
      console.log(chalk.dim('\n⏳ Processing...\n'));
      const response = await this.queryOllama(input);
      this.conversations.push(
        { role: 'user', content: input, timestamp: new Date() },
        { role: 'assistant', content: response, timestamp: new Date() }
      );
      console.log(chalk.green('Assistant:'));
      console.log(chalk.white(response));
      console.log();
    }
  }

  startRepl() {
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout,
      prompt: chalk.cyan('ollama> ')
    });

    rl.prompt();

    rl.on('line', async (line) => {
      const input = line.trim();
      if (input.toLowerCase() === 'exit') {
        console.log(chalk.cyan('Goodbye!'));
        rl.close();
        process.exit(0);
      }

      if (input) {
        await this.handleUserInput(input);
      }

      rl.prompt();
    });

    rl.on('close', () => {
      process.exit(0);
    });
  }

  async run() {
    this.printWelcome();
    this.startRepl();
  }
}

const agent = new OllamaAgent();
agent.run();