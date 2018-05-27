tpower <- function(x, t, p)
# Truncated p-th power function
    (x - t) ^ p * (x > t)


bbase <- function(x, xl = min(x), xr = max(x), nseg = 10, deg = 3){
# Construct B-spline basis
    dx <- (xr - xl) / nseg
    knots <- seq(xl - deg * dx, xr + deg * dx, by = dx)
    P <- outer(x, knots, tpower, deg)
    n <- dim(P)[2]
    D <- diff(diag(n), diff = deg + 1) / (gamma(deg + 1) * dx ^ deg)
    B <- (-1) ^ (deg + 1) * P %*% t(D)
    B }

gauss <- function(x, mu, sig) {
# Gaussian-shaped function
    u <- (x - mu) / sig
    y <- exp(- u * u / 2)
    y }

gbase <- function(x, mus) {
# Construct Gaussian basis
    sig <- (mus[2] - mus[1]) / 2
    G <- outer(x, mus, gauss, sig)
    G }

pbase <- function(x, n) {
# Construct polynomial basis
    u <- (x - min(x)) / (max(x) - min(x))
    u <- 2 * (u - 0.5);
    P <- outer(u, seq(0, n, by = 1), "^")
    P }
