extern crate minifb;

use minifb::{Key, Window, WindowOptions};
use std::{thread, time};
const NUM_X: usize = 150 + 2;
const NUM_Y: usize = 75 + 2;
const OVER_RELAXATION: f64 = 1.9;
const DENSITY: f64 = 1000.0;
const NUM_CELLS: usize = NUM_X * NUM_Y;
const H: f64 = 0.01;
//static mut U: [f64; NUM_CELLS] = [0.0; NUM_CELLS];
//static mut V: [f64; NUM_CELLS] = [0.0; NUM_CELLS];
//static mut NEW_U: [f64; NUM_CELLS] = [0.0; NUM_CELLS];
//static mut NEW_V: [f64; NUM_CELLS] = [0.0; NUM_CELLS];
//static mut P: [f64; NUM_CELLS] = [0.0; NUM_CELLS];
//static mut S: [f64; NUM_CELLS] = [0.0; NUM_CELLS];
//static mut M: [f64; NUM_CELLS] = [0.0; NUM_CELLS];
//static mut NEW_M: [f64; NUM_CELLS] = [0.0; NUM_CELLS];

//const WIDTH: usize = 640;
//const HEIGHT: usize = 360;
const WIDTH: usize = NUM_Y;
const HEIGHT: usize = NUM_X;

fn main() {
    //let myfluid=Fluid{
    //    over_relaxation:1.9,
    //   density:1000.0,
    //   num_x:75,
    //   num_y:100,
    //   num_cells:NUM_X*NUM_Y,
    //   h:0.01,
    //  u:[0.0;NUM_X*NUM_Y],
    //};
    //println!("{}, {}",OVER_, myfluid.density);

    //let mut U: [f64; NUM_CELLS] = vec![0.0; NUM_CELLS];
    //let mut V: [f64; NUM_CELLS] = vec![0.0; NUM_CELLS];
    //let mut NEW_U: [f64; NUM_CELLS] = vec![0.0; NUM_CELLS];
    //let mut NEW_V: [f64; NUM_CELLS] = vec![0.0; NUM_CELLS];
    //let mut P: [f64; NUM_CELLS] = vec![0.0; NUM_CELLS];
    //let mut S: [f64; NUM_CELLS] = vec![0.0; NUM_CELLS];
    //let mut M: [f64; NUM_CELLS] = vec![0.0; NUM_CELLS];
    //let mut NEW_M: [f64; NUM_CELLS] = vec![0.0; NUM_CELLS];

    let mut U = vec![0.0; NUM_CELLS];
    let mut V = vec![0.0; NUM_CELLS];
    let mut NEW_U = vec![0.0; NUM_CELLS];
    let mut NEW_V = vec![0.0; NUM_CELLS];
    let mut P = vec![0.0; NUM_CELLS];
    let mut S = vec![0.0; NUM_CELLS];
    let mut M = vec![1.0; NUM_CELLS];
    let mut NEW_M = vec![0.0; NUM_CELLS];

    setWallsAndIncoming(&mut U, &mut S, &mut M);

    set_obstacle(0.4, 0.35, &mut S, &mut U, &mut V, &mut M);
    //let mut framebuffer: [u32; WIDTH * HEIGHT] = [0; WIDTH * HEIGHT];
    //println!("{}",S);
    //deal_with_windows(&mut framebuffer, &S);
    //
    //let obstacle = &S;
    let mut buffer: Vec<u32> = vec![0; WIDTH * HEIGHT];
    let mut window = Window::new(
        "Test - ESC to exit",
        WIDTH,
        HEIGHT,
        WindowOptions::default(),
    )
    .unwrap_or_else(|e| {
        panic!("{}", e);
    });
    for i in 0..NUM_X {
        for j in 0..NUM_Y {
            //unsafe {
            buffer[i * NUM_Y + j] = 255 * S[i * NUM_Y + j] as u32;
            //}
        }
    }
    // Limit to max ~60 fps update rate
    window.limit_update_rate(Some(std::time::Duration::from_micros(16600)));
    println!("init done");

    while window.is_open() && !window.is_key_down(Key::Escape) {
        //for item in buffer.iter_mut() {
        //    *item = 0; // write something more funny here!

        //}
        //
        //
        //println!("starting sim");
        simulate(
            0.01, 0.0, 100, &mut U, &mut NEW_U, &mut V, &mut NEW_V, &mut S, &mut P, &mut M,
            &mut NEW_M,
        );
        //println!("simulating done, sleeping 1 second");
        //thread::sleep(time::Duration::from_secs(5));

        //for (k, val) in buffer.iter_mut().enumerate() {
        //    let j = k % NUM_Y;
        //    let i = k - j;
        //unsafe {
        //*val = 100 * obstacle[i + j] as u32;
        //}
        let n = NUM_Y;
        for i in 0..NUM_X {
            for j in 0..NUM_Y {
                buffer[i * n + j] = (255.0 * M[i * n + j]) as u32;
                if (i==0){
                    U[i*n+j]=2.0;
                }
            }

            //println!("{}",item);
        }

        // We unwrap here as we want this code to exit if it fails. Real applications may want to handle this in a different way
        window.update_with_buffer(&buffer, WIDTH, HEIGHT).unwrap();
    }

    //fn simulate(dt:f64, gravity:f64, numIters:usize, u: &mut [f64], newU: &mut [f64], v:&mut [f64], newV: &mut [f64], s:&mut[f64], P: &mut [f64] , m: &mut [f64], newM: &mut[f64]){
}

fn setWallsAndIncoming(u: &mut [f64], s: &mut [f64], m: &mut [f64]) {
    println!("numCells is {}", { NUM_CELLS });
    let n = NUM_Y;
    let inVel = 2.0;
    for i in 0..NUM_X {
        for j in 0..NUM_Y {
            let mut s_loc = 1.0;
            if (i == 0 || j == 0 || j == NUM_Y - 1) {
                s_loc = 0.0;
            }
            //if i * n + j > 11702 {
                //println!("i is {}\n j is {}", { i }, { j });
            //}
            //println!("len of s is {}", { s.len() });
            //println!("i*n+j= {}", { i * n + j });
            s[i * n + j] = s_loc;
            if (i <= 1) {
                u[i * n + j] = inVel;
            }
        }
    }
    let pipeH = 0.1 * (NUM_Y as f64);
    let minJ = (0.5 * (NUM_Y as f64) - 0.5 * pipeH).floor() as usize;
    let maxJ = (0.5 * (NUM_Y as f64) + 0.5 * pipeH).floor() as usize;
    for i in 0..2{
    for j in minJ..maxJ-1{
        m[i*n+j]=0.0;

    }
    }
}

fn set_obstacle(x: f64, y: f64, s: &mut [f64], u: &mut [f64], v: &mut [f64], m: &mut [f64]) {
    //scene.obstacleX = x;
    //scene.obstacleY = y;

    let vx: f64 = 0.0;
    let vy: f64 = 0.0;

    //if !reset {
    //    vx = (x - scene.obstacleX) / scene.dt;
    //    vy = (y - scene.obstacleY) / scene.dt;
    //}

    let r = 0.15;
    //let mut  i: u16 = 1;

    for i in 1..NUM_X - 1 {
        for j in 1..NUM_Y - 1 {
            //unsafe {
            s[i * NUM_Y + j] = 1.0;

            let dx: f64 = (i as f64 + 0.5) * H - x;
            let dy: f64 = (j as f64 + 0.5) * H - y;

            if dx * dx + dy * dy < r * r {
                s[i * NUM_Y + j] = 0.0;
                m[i*NUM_Y + j] = 1.0;
                u[i * NUM_Y + j] = vx;
                u[(i + 1) * NUM_Y + j] = vx;
                v[i * NUM_Y + j] = vy;
                v[i * NUM_Y + j + 1] = vy;
            }
            //}
        }
    }
}

fn deal_with_windows_and_simulate(buffer: &mut [u32], obstacle: &[f64]) {
    //let mut buffer: Vec<u32> = vec![0; WIDTH * HEIGHT];
    let mut window = Window::new(
        "Test - ESC to exit",
        WIDTH,
        HEIGHT,
        WindowOptions::default(),
    )
    .unwrap_or_else(|e| {
        panic!("{}", e);
    });
    for i in 0..NUM_X {
        for j in 0..NUM_Y {
            //unsafe {
            buffer[i * NUM_Y + j] = 100 * obstacle[i * NUM_Y + j] as u32;
            //}
        }
    }
    // Limit to max ~60 fps update rate
    window.limit_update_rate(Some(std::time::Duration::from_micros(16600)));

    while window.is_open() && !window.is_key_down(Key::Escape) {
        //for item in buffer.iter_mut() {
        //    *item = 0; // write something more funny here!

        //}
        //
        //simulate(  )
        for (k, val) in buffer.iter_mut().enumerate() {
            let j = k % NUM_Y;
            let i = k - j;
            //unsafe {
            *val = 100 * obstacle[i + j] as u32;
            //}
            //println!("{}",item);
        }

        // We unwrap here as we want this code to exit if it fails. Real applications may want to handle this in a different way
        window.update_with_buffer(&buffer, WIDTH, HEIGHT).unwrap();
    }
}

fn integrate(dt: f64, gravity: f64, s: &mut [f64], v: &mut [f64]) {
    let n = NUM_Y;
    let mut i: usize = 1;
    while (i < NUM_X) {
        let mut j: usize = 1;
        while (j < NUM_Y - 1) {
            if (s[i * n + j] != 0.0 && s[i * n + j - 1] != 0.0) {
                v[i * n + j] += gravity * dt;
            }
            j += 1;
        }
        i += 1;
    }
}

fn solveIncompressibility(
    numIters: usize,
    dt: f64,
    s: &[f64],
    u: &mut [f64],
    v: &mut [f64],
    P: &mut [f64],
) {
    let n = NUM_Y;
    let cp = DENSITY * H / dt;

    for iter in 0..numIters {
        for i in 1..NUM_X - 1 {
            for j in 1..NUM_Y - 1 {
                if (s[i * n + j] == 0.0) {
                    continue;
                }
                let sx0 = s[(i - 1) * n + j];
                let sx1 = s[(i + 1) * n + j];
                let sy0 = s[i * n + j - 1];
                let sy1 = s[i * n + j + 1];
                let s_local = sx0 + sx1 + sy0 + sy1;
                if (s_local == 0.0) {
                    continue;
                }
                let div = u[(i + 1) * n + j] - u[i * n + j] + v[i * n + j + 1] - v[i * n + j];
                let mut p = -div / s_local;

                p *= OVER_RELAXATION;
                P[i * n + j] += cp * p;
                u[i * n + j] -= sx0 * p;
                u[(i + 1) * n + j] += sx1 * p;
                v[i * n + j] -= sy0 * p;
                v[i * n + j + 1] += sy1 * p;
            }
        }
    }
}

fn extrapolate(u: &mut [f64], v: &mut [f64]) {
    let n = NUM_Y;
    for i in 0..NUM_X {
        u[i * n + 0] = u[i * n + 1];
        u[i * n + NUM_Y - 1] = u[i * n + NUM_Y - 2];
    }
    for j in 0..NUM_Y {
        v[0 * n + j] = v[1 * n + j];
        v[(NUM_X - 1) * n + j] = v[(NUM_X - 2) * n + j];
    }
}

fn max(x: f64, y: f64) -> f64 {
    if x > y {
        x
    } else {
        y
    }
}

fn min(x: f64, y: f64) -> f64 {
    if y > x {
        x
    } else {
        y
    }
}

fn sampleField(xi: f64, yi: f64, field: char, f: &[f64]) -> f64 {
    let n = NUM_Y;
    let h = H;
    let h1 = 1.0 / h;
    let h2 = 0.5 * h;
    let x: f64 = max(min(xi, NUM_X as f64), h);

    let y: f64 = max(min(yi, NUM_Y as f64), h);

    let mut dx = 0.0;
    let mut dy = 0.0;
    match field {
        'u' => {
            //f=fluid.u
            dy = h2;
        }
        'v' => {
            //f=fluid.v
            dx = h2;
        }
        'm' => {
            //f=fluid.m
            dx = h2;
            dy = h2;
        }
        _ => {
            println!("invalid field:  {}", { field });
        }
    }
    let x0 = (min(((x - dx) * h1).floor() as f64, (NUM_X - 1) as f64)) ;
    let tx = ((x - dx) - x0 * h) * h1;
    let x1 = (min(x0 + 1.0, (NUM_X - 1) as f64));
    let y0 = (min(((y - dy) * h1).floor() as f64, (NUM_Y - 1) as f64));
    let ty = ((y - dy) - y0 * h) * h1;
    let y1 = min(y0 + 1.0, (NUM_Y - 1) as f64)+0.5;
    let sx = 1.0 - tx;
    let sy = 1.0 - ty;

    let val = sx * sy * f[(x0 * (n as f64) + y0) as usize]
        + tx * sy * f[(x1 * (n as f64) + y0) as usize]
        + tx * ty * f[(x1 * (n as f64) + y1) as usize]
        + sx * ty * f[(x0 * (n as f64) + y1) as usize];
    return val;
}
fn avgU(i: usize, j: usize, u: &[f64]) -> f64 {
    let n = NUM_Y;
    let U = (u[i*n+j-1] + u[i*n+j] + u[(i+1)*n+j-1] + u[(i+1)*n+j]) * 0.25;
    return U;
}

fn avgV(i: usize, j: usize, v: &[f64]) -> f64 {
    let n = NUM_Y;
    let V = (v[(i - 1) * n + j] + v[i * n + j] + v[(i - 1) * n + j + 1] + v[i * n + j + 1]) * 0.25;
    return V;
}

fn advectVel(dt: f64, u: &mut [f64], newU: &mut [f64], v: &mut [f64], newV: &mut [f64], s: &[f64]) {
    //write contents of u into newU
    if u.len() != newU.len() {
        panic!("arrays are different sizes!")
    };
    for i in 0..u.len() {
        newU[i] = u[i];
    }
    if v.len() != newV.len() {
        panic!("arrays are different sizes!")
    };
    for i in 0..v.len() {
        newV[i] = v[i];
    }

    let n = NUM_Y;
    let h = H;
    let h2 = 0.5 * h;
    for i in 1..NUM_X-1 {
        for j in 1..NUM_Y-1 {
            if s[i * n + j] != 0.0 && s[(i - 1) * n + j] != 0.0 && j < (NUM_Y - 1) {
                let mut x: f64 = (i as f64) * h;
                let mut y: f64 = (j as f64) * h + h2;
                let mut u_local = u[i * n + j];
                let v_local = avgV(i, j, v);
                x = x - dt * u_local;
                y = y - dt * v_local;
                u_local = sampleField(x, y, 'u', u);
                newU[i * n + j] = u_local;
            }

            if s[i * n + j] != 0.0 && s[i * n + j - 1] != 0.0 && j < (NUM_X - 1) {
                let mut x: f64 = (i as f64) * h + h2;
                let mut y: f64 = (j as f64) * h;
                let u_local2 = avgU(i, j, u);
                let mut v_local2 = v[i * n + j];
                x = x - dt * u_local2;
                y = y - dt * v_local2;
                v_local2 = sampleField(x, y, 'v', v);
                newV[i * n + j] = v_local2;
            }
        }
    }
    if u.len() != newU.len() {
        panic!("arrays are different sizes!")
    };
    for i in 0..u.len() {
        u[i] = newU[i];
    }
    if v.len() != newV.len() {
        panic!("arrays are different sizes!")
    };
    for i in 0..v.len() {
        v[i] = newV[i];
    }
}

fn advectSmoke(dt: f64, m: &mut [f64], newM: &mut [f64], s: &[f64], u: &[f64], v: &[f64]) {
    for i in 0..m.len() {
        newM[i] = m[i];
    }
    let n = NUM_Y;
    let h = H;
    let h2 = 0.5 * h;
    for i in 1..(NUM_X - 1) {
        for j in (1..NUM_Y - 1) {
            if s[i * n + j] != 0.0 {
                let u_local = (u[i * n + j] + u[(i + 1) * n + j]) * 0.5;
                let v_local = (v[i * n + j] + v[i * n + j + 1]) * 0.5;
                let x = (i as f64) * h + h2 - dt * u_local;
                let y = (j as f64) * h + h2 - dt * v_local;
                newM[i * n + j] = sampleField(x, y, 'm', m);
            }
        }
    }
    for i in 0..m.len() {
        m[i] = newM[i];
    }
}

fn simulate(
    dt: f64,
    gravity: f64,
    numIters: usize,
    u: &mut [f64],
    newU: &mut [f64],
    v: &mut [f64],
    newV: &mut [f64],
    s: &mut [f64],
    P: &mut [f64],
    m: &mut [f64],
    newM: &mut [f64],
) {
    //integrate(dt, gravity, s, v);
    for i in 0..P.len() {
        P[i] = 0.0;
    }
    //probably
    //println!("integration done");
    solveIncompressibility(numIters, dt, s, u, v, P);
    //println!("incompressibility done");
    extrapolate(u, v);
    //println!("extrapolate done");
    advectVel(dt, u, newU, v, newV, s);
    //println!("advectVel done");
    advectSmoke(dt, m, newM, s, u, v);
    //println!("advectSmoke done");
}




