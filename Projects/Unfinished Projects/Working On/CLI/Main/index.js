#!/usr/bin/env node

import chalk from 'chalk';
import inquirer from 'inquirer';
import chalkAnimation from 'chalk-animation';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);
const sleep = (ms = 800) => new Promise(r => setTimeout(r, ms));

/* -------------------------------------------------- */
/* MAIN                                               */
/* -------------------------------------------------- */




async function run() {
    const title = chalkAnimation.glitch('PROJECT INITIZER CLI');
    await sleep();
    title.stop();

    const { appName } = await inquirer.prompt({
    name: 'appName',
    type: 'input',
    message: 'Enter project name:',
    default: 'demo'
  });

    fs.mkdirSync(appName, { recursive: true });
    process.chdir(appName);

    const { stack } = await inquirer.prompt({
    type: "checkbox",
    name: "stack",
    message: "Select what stack you need",
    choices: [
          "Frontend",
                "Backend",
                      "Database (with Docker)"
                          ]
  });

    console.log("Selected stack:", stack);
    
}

