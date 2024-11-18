{
  lib,
  user,
  ...
}:
{
  # vmVariantにあれこれ書いておくとbuild-vmの時だけ使われる
  virtualisation.vmVariant = {
    # hashPasswordFileを使っているので解除した上でユーザー名をそのままパスワードにする
    users.users.${user} = {
      hashedPasswordFile = lib.mkForce null;
      initialPassword = user;
    };
  };
}
