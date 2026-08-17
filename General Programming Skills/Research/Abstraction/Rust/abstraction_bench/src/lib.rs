pub fn sum_squares_iter(data: &[i64]) -> i64 {
    data.iter().map(|x| x * x).filter(|x| x % 2 == 0).sum()
}

pub fn sum_squares_manual(data: &[i64]) -> i64 {
    let mut total = 0;
    for i in 0..data.len() {
        let sq = data[i] * data[i];
        if sq % 2 == 0 {
            total += sq;
        }
    }
    total
}

pub fn sum_squares_boxed(data: &[i64]) -> i64 {
    let it: Box<dyn Iterator<Item = i64>> =
        Box::new(data.iter().map(|x| x * x).filter(|x| x % 2 == 0));
    it.sum()
}

// Two-pass "hand-optimized" version
#[inline(never)]
pub fn variance_two_pass(data: &[f64]) -> f64 {
    let n = data.len() as f64;
    let mut sum = 0.0;
    for &x in data { sum += x; }
    let mean = sum / n;
    let mut var = 0.0;
    for &x in data { var += (x - mean).powi(2); }
    var / n
}

// Welford's single-pass algorithm — only expressible cleanly via a fold abstraction
pub fn variance_welford(data: &[f64]) -> f64 {
    let (_, _, m2) = data.iter().fold((0i64, 0.0_f64, 0.0_f64), |(count, mean, m2), &x| {
        let count = count + 1;
        let delta = x - mean;
        let mean = mean + delta / count as f64;
        let delta2 = x - mean;
        (count, mean, m2 + delta * delta2)
    });
    m2 / data.len() as f64
}