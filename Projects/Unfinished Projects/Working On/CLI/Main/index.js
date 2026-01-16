#!/usr/bin/env node

import chalk from 'chalk';
import inquirer from 'inquirer';
import chalkAnimation from 'chalk-animation';
import { exec } from 'child_process';
import { promisify } from 'util';
import { createSpinner } from 'nanospinner';
import qs from 'qs';
import fs from 'fs';

const execAsync = promisify(exec);
const sleep = (ms = 800) => new Promise(r => setTimeout(r, ms));

/* -------------------------------------------------- */
/* SPRING BOOT PROMPTS                                */
/* -------------------------------------------------- */

async function promptSpringBootConfig() {
  return inquirer.prompt([
    {
      type: 'checkbox',
      name: 'type',
      message: 'Project type',
      choices: [
        { name: 'Maven', value: 'maven-project' },
        { name: 'Gradle', value: 'gradle-project' }
      ],
      validate: a => a.length === 1 || 'Select exactly one'
    },
    {
      type: 'checkbox',
      name: 'language',
      message: 'Language',
      choices: ['java', 'kotlin', 'groovy'],
      validate: a => a.length === 1 || 'Select exactly one'
    },
    {
      type: 'checkbox',
      name: 'javaVersion',
      message: 'Java version',
      choices: ['21', '17', '11'],
      validate: a => a.length === 1 || 'Select exactly one'
    },
    {
      type: 'input',
      name: 'groupId',
      message: 'Group ID',
      default: 'com.example'
    },
    {
      type: 'input',
      name: 'artifactId',
      message: 'Artifact ID',
      default: 'demo'
    },
    {
      type: 'checkbox',
      name: 'dependencies',
      message: 'Dependencies',
      choices: [
        { name: 'Spring Web', value: 'web' },
        { name: 'Spring Data JPA', value: 'data-jpa' },
        { name: 'Spring Security', value: 'security' },
        { name: 'Actuator', value: 'actuator' }
      ]
    }
  ]);
}

/* -------------------------------------------------- */
/* DJANGO FLOW                                        */
/* -------------------------------------------------- */

async function runDjangoFlow(appName) {
  const spinner = createSpinner('Checking Python').start();

  try {
    await execAsync('python3 --version');
    spinner.success({ text: 'Python detected' });
  } catch {
    spinner.error({ text: 'Python not installed' });
    process.exit(1);
  }

  const venvDir = '.venv';

  if (!fs.existsSync(venvDir)) {
    const venvSpinner = createSpinner('Creating virtual environment').start();
    await execAsync(`python3 -m venv ${venvDir}`);
    venvSpinner.success({ text: 'Virtual environment created' });
  }

  const pip = `${venvDir}/bin/pip`;
  const djangoAdmin = `${venvDir}/bin/django-admin`;

  const djangoSpinner = createSpinner('Installing Django').start();
  await execAsync(`${pip} install django`);
  djangoSpinner.success({ text: 'Django installed' });

  const projectSpinner = createSpinner('Creating Django project').start();
  await execAsync(`${djangoAdmin} startproject ${appName}`);
  projectSpinner.success({ text: 'Django project created' });

  console.log(
    chalk.green(`
✔ Django project ready
✔ Activate with: source .venv/bin/activate
✔ Run server: python manage.py runserver
`)
  );
}

/* -------------------------------------------------- */
/* SPRING BOOT FLOW                                   */
/* -------------------------------------------------- */

async function runSpringBootFlow() {
  const javaSpinner = createSpinner('Checking Java').start();
  try {
    await execAsync('java --version');
    javaSpinner.success({ text: 'Java detected' });
  } catch {
    javaSpinner.error({ text: 'Java not found' });
    process.exit(1);
  }

  const config = await promptSpringBootConfig();

  const params = {
    type: config.type[0],
    language: config.language[0],
    javaVersion: config.javaVersion[0],
    groupId: config.groupId,
    artifactId: config.artifactId,
    name: config.artifactId,
    dependencies: config.dependencies
  };

  const query = qs.stringify(params, { arrayFormat: 'comma' });
  const url = `https://start.spring.io/starter.zip?${query}`;

  const downloadSpinner = createSpinner('Downloading Spring Boot project').start();
  await execAsync(`curl -L "${url}" -o app.zip`);
  downloadSpinner.success({ text: 'Spring Boot project downloaded' });

  console.log(
    chalk.green(`
✔ Spring Boot project ready
✔ File: app.zip
✔ Unzip and start coding
`)
  );
}

/* -------------------------------------------------- */
/* MAIN                                               */
/* -------------------------------------------------- */

async function run() {
  const title = chalkAnimation.glitch('BACKEND PROJECT CLI');
  await sleep();
  title.stop();

  const { appName } = await inquirer.prompt({
    name: 'appName',
    type: 'input',
    message: 'Enter project name:',
    default: 'demo'
  });

  const { backend } = await inquirer.prompt({
    name: 'backend',
    type: 'checkbox',
    message: 'Select backend',
    choices: [
      { name: 'Java : Spring Boot', value: 'spring' },
      { name: 'Python : Django', value: 'django' }
    ],
    validate: a => a.length === 1 || 'Select exactly one backend'
  });

  if (backend[0] === 'spring') {
    await runSpringBootFlow();
  } else {
    await runDjangoFlow(appName);
  }
}

run().catch(err => {
  console.error(chalk.red('CLI Error:'), err);
  process.exit(1);
});

