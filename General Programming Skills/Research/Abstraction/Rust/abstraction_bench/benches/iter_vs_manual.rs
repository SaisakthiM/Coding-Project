use criterion::{criterion_group, criterion_main, BenchmarkId, Criterion, black_box};
use abstraction_bench::{variance_two_pass, variance_welford};

fn bench(c: &mut Criterion) {
    let mut group = c.benchmark_group("variance");
    for n in [10_000usize, 1_000_000, 10_000_000] {
        let data: Vec<f64> = (0..n).map(|i| i as f64).collect();
        group.bench_with_input(BenchmarkId::new("two_pass", n), &data, |b, d| b.iter(|| variance_two_pass(black_box(d))));
        group.bench_with_input(BenchmarkId::new("fold_welford", n), &data, |b, d| b.iter(|| variance_welford(black_box(d))));
    }
    group.finish();
}
criterion_group!(benches, bench);
criterion_main!(benches);