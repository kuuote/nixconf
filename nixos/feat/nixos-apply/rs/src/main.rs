use std::path::PathBuf;
use std::process::Command;
use std::{env, fs};

fn check_switcher(path: &PathBuf) -> Option<()> {
    let buf = fs::read_to_string(path).ok()?;
    buf.find("/nix/store")?;
    buf.find("switch-to-configuration-wrapped")?;
    Some(())
}

fn main() {
    let mut args = env::args();
    let _ = args.next();
    let path = fs::canonicalize(args.next().unwrap()).unwrap();
    let switcher = path.join("bin/switch-to-configuration");
    let action = args.next().unwrap();
    check_switcher(&switcher).unwrap();
    // setuidビット設定しててもsetuid叩かないと伝播しないらしい
    unsafe { libc::setuid(0) };
    let install_profile = match &*action {
        "boot" => true,
        "switch" => true,
        "test" => false,
        _ => panic!("unknown action: {}", action),
    };
    if install_profile {
        Command::new("nix-env")
            .args(["-p", "/nix/var/nix/profiles/system", "--set"])
            .arg(path)
            .status()
            .unwrap();
    }
    Command::new(switcher).arg(action).status().unwrap();
}
