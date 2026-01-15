import chalk from 'chalk';
import inquirer from 'inquirer';
import chalkAnimation from 'chalk-animation';
import { exec, spawn } from 'child_process';
import { promisify } from 'util';
import { createSpinner } from 'nanospinner';
import qs from 'qs';
import fs from 'fs';


const execAsync = promisify(exec);
const sleep = (ms = 800) => new Promise(r => setTimeout(r, ms));

async function reactInitizer() {
  try {
    const Spinner = createSpinner('Checking Node JS Version')
    await execAsync("node -v")
    Spinner.success("Node JS Exists, Starting Vite Initializer")
    await spawn("npm create vite@latest") 
    Spinner.success("Frontend Initialized");

  }
  catch (err) {
    console.err(err);
  }


}
