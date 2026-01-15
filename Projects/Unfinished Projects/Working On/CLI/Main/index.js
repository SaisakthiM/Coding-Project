#!/usr/bin/env node

import chalk from 'chalk';
import inquirer from 'inquirer';
import chalkAnimation from 'chalk-animation';
import { exec } from 'child_process';
import { promisify } from 'util';
import { createSpinner } from 'nanospinner';
import qs from 'qs';
import { version } from 'os';

const execAsync = promisify(exec);

const sleep = (ms = 800) =>
  new Promise(resolve => setTimeout(resolve, ms));

/* ---------------- Spring Boot Prompts ---------------- */

async function promptSpringBootConfig() {
  return await inquirer.prompt([
    {
      type: 'checkbox',
      name: 'type',
      message: 'Project type',
      choices: [
        { name: 'Maven', value: 'maven-project' },
        { name: 'Gradle', value: 'gradle-project' }
      ],
      default: 'maven-project'
    },
    {
      type: 'checkbox',
      name: 'language',
      message: 'Language',
      choices: ['java', 'kotlin', 'groovy'],
      default: 'java'
    },
    {
      type: 'checkbox',
      name: 'javaVersion',
      message: 'Java version',
      choices: ['21', '17', '11'],
      default: '17'
    },
    {
      type: 'input',
      name: 'groupId',
      message: 'Group ID',
      default: 'com.example',
      validate: v =>
        /^[a-zA-Z_][\w.]*$/.test(v) || 'Invalid Java package name'
    },
    {
      type: 'input',
      name: 'artifactId',
      message: 'Artifact ID',
      default: 'demo',
      validate: v =>
        /^[a-zA-Z_][\w-]*$/.test(v) || 'Invalid artifact name'
    },
    {
      type: 'input',
      name: 'name',
      message: 'Project name',
      default: answers => answers.artifactId
    },
    {
      type: 'checkbox',
      name: 'dependencies',
      message: 'Select dependencies',
      choices: [
        { name: 'Spring Web', value: 'web' },
        { name: 'Spring Data JPA', value: 'data-jpa' },
        { name: 'Spring Security', value: 'security' },
        { name: 'Spring Validation', value: 'validation' },
        { name: 'Spring Actuator', value: 'actuator' }
      ]
    }
  ]);
}

async function PythonPrompt() {
  return await inquirer.prompt(
    {
      name: "Project Name",
      type: "input",
      message: "Give a Project Name", 
      default: "main"
    }
  ) 
}

/* ---------------- Main Runner ---------------- */

async function run() {
  // Intro animation
  const title = chalkAnimation.glitch('SPRING BOOT CLI');
  await sleep();
  title.stop();

  // App folder name
  const { appName } = await inquirer.prompt({
    name: 'appName',
    type: 'input',
    message: 'Enter project folder name:',
    default: 'demo'
  });

  // Backend selection (checkbox)
  const { backend } = await inquirer.prompt({
    name: 'backend',
    type: 'checkbox',
    message: 'Select backend stack:',
    choices: [
      { name: 'Java : Spring Boot', value: 'spring' },
      { name: 'Python : Django', value: 'django' }
    ],
    validate: ans =>
      ans.length === 1 || 'Please select exactly one backend'
  });

  if (backend.includes('django')) {
     const Spinner = createSpinner('Checking Python installation').start();
     const {venv} = await inquirer.prompt(
      {
        type: "input",
        name: "venv", 
        message: "Enter your venv path if you have one, (leave this empty if you don't have one)"
      }
    )
    try {
          await execAsync('python --version');
          Spinner.success({ text: 'Python detected' });
          if (!venv) {
            execAsync()
          }
          await execAsync("pip install -r django")
          Spinner.success({text: "Django Module Installed"})

        } catch (err){
          Spinner.error({ text: `Error : ${err} ` });
          process.exit(1);
        }
    
  }

  /* ---------- Java Check ---------- */
  if (backend[0] === 'spring') {
  const javaSpinner = createSpinner('Checking Java installation').start();
  try {
    await execAsync('java --version');
    javaSpinner.success({ text: 'Java detected' });
  } catch {
    javaSpinner.error({ text: 'Java not found in PATH' });
    process.exit(1);
  }

  /* ---------- Spring Boot Config ---------- */

  const config = await promptSpringBootConfig();

  const params = {
    type: config.type,
    language: config.language,
    javaVersion: config.javaVersion,
    groupId: config.groupId,
    artifactId: config.artifactId,
    name: config.name,
    dependencies: config.dependencies
  };

  const query = qs.stringify(params, { arrayFormat: 'comma' });
  const url = `https://start.spring.io/starter.zip?${query}`;

  /* ---------- Download ---------- */

  const downloadSpinner = createSpinner(
    'Downloading Spring Boot project'
  ).start();

  try {
    await execAsync(`curl -L "${url}" -o app.zip`);
    downloadSpinner.success({ text: 'Spring Boot project downloaded (app.zip)' });
  } catch {
    downloadSpinner.error({ text: 'Download failed' });
    process.exit(1);
  }

  console.log(
    chalk.green(`
✔ Spring Boot project ready
✔ File: app.zip
✔ You can now unzip and start developing
`)
  ); }
}

/* ---------------- Execute ---------------- */

run().catch(err => {
  console.error(chalk.red('CLI Error:'), err);
  process.exit(1);
});



















































