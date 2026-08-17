// Run with: node --allow-natives-syntax monomorphic_vs_polymorphic.js

function getX(obj) { return obj.x; }

function bench(name, fn) {
  const start = process.hrtime.bigint();
  fn();
  const end = process.hrtime.bigint();
  console.log(`${name}: ${(end - start) / 1000000n}ms`);
}

// (1) Monomorphic: every object has the same "shape" (hidden class)
function monomorphic() {
  let sum = 0;
  for (let i = 0; i < 10_000_000; i++) {
    const o = { x: i, y: 0 };   // same shape every time
    sum += getX(o);
  }
  return sum;
}

// (2) Polymorphic/megamorphic: shape varies, breaks inline caching
function polymorphic() {
  let sum = 0;
  for (let i = 0; i < 10_000_000; i++) {
    let o;
    if (i % 3 === 0) o = { x: i, y: 0 };
    else if (i % 3 === 1) o = { x: i, z: 0, y: 0 };       // different key order/shape
    else o = { x: i, y: 0, w: 0, extra: true };
    sum += getX(o);
  }
  return sum;
}

// Someone "optimizes" by flattening to parallel arrays, avoiding object abstraction
function flatArrays(n) {
  const xs = new Float64Array(n), ys = new Float64Array(n);
  for (let i = 0; i < n; i++) { xs[i] = i; ys[i] = i * 2; }
  let sum = 0;
  for (let i = 0; i < n; i++) sum += xs[i] + ys[i];
  return sum;
}

// Object abstraction, but shape-stable — V8 can treat this almost like a struct
function stableObjects(n) {
  const points = [];
  for (let i = 0; i < n; i++) points.push({ x: i, y: i * 2 }); // consistent shape
  let sum = 0;
  for (const p of points) sum += p.x + p.y;
  return sum;
}

bench("monomorphic", monomorphic);
bench("polymorphic", polymorphic);

// Inspect actual JIT behavior, not just timing:
console.log(%GetOptimizationStatus(getX));