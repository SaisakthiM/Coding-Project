// bench.js — run with: node --allow-natives-syntax bench.js

function getX(obj) { return obj.x; }

function makeMonoBatch(n) {
  const arr = new Array(n);
  for (let i = 0; i < n; i++) arr[i] = { x: i, y: 0 };
  return arr;
}

function makePolyBatch(n) {
  const arr = new Array(n);
  for (let i = 0; i < n; i++) {
    if (i % 3 === 0) arr[i] = { x: i, y: 0 };
    else if (i % 3 === 1) arr[i] = { x: i, z: 0, y: 0 };
    else arr[i] = { x: i, y: 0, w: 0, extra: true };
  }
  return arr;
}

function sumX(arr) {
  let sum = 0;
  for (let i = 0; i < arr.length; i++) sum += getX(arr[i]);
  return sum;
}

function runTrial(label, arr) {
  // Warmup: let TurboFan compile and specialize before timing
  for (let w = 0; w < 5; w++) sumX(arr);

  const times = [];
  for (let r = 0; r < 7; r++) {
    const start = process.hrtime.bigint();
    sumX(arr);
    const end = process.hrtime.bigint();
    times.push(Number(end - start) / 1e6); // ms
  }
  times.sort((a, b) => a - b);
  const median = times[Math.floor(times.length / 2)];
  console.log(`${label}: median=${median.toFixed(3)}ms  all=[${times.map(t => t.toFixed(3)).join(', ')}]`);
}

const N = 5_000_000;
const monoData = makeMonoBatch(N);
const polyData = makePolyBatch(N);

runTrial('monomorphic', monoData);
runTrial('polymorphic', polyData);

console.log('getX optimization status:', %GetOptimizationStatus(getX));