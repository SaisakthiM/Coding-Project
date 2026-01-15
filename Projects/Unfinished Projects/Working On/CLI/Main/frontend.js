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

function runViteInit() {
    return new Promise((resolve, reject) => {
        const child = spawn(
              'npm',
                    ['create', 'vite@latest'],
                          {
                                  stdio: 'inherit', // <-- critical
                                          shell: true
                                                }
                                                    );

                                                        child.on('close', code => {
                                                              if (code === 0) resolve();
                                                                    else reject(new Error(`Vite exited with code ${code}`));
                                                                        });
                                                                          });
}

async function reactInitizer() {
  try {
  const Spinner = createSpinner('Checking Node JS Version')
  const {res} = await execAsync("node -v")
  Spinner.success("Node JS Exists, Starting Vite Initializer")

  }
  catch (err) {
    console.err(err);
  }


}
