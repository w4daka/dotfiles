{
   description = "A devbox shell";

   inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs/608d0cadfed240589a7eea422407a547ad626a14";
     nixpkgs-61684d.url = "github:NixOS/nixpkgs/61684d356e41c97f80087e89659283d00fe032ab";
   };

   outputs = {
     self,
     nixpkgs,
     nixpkgs-61684d,
   }:
      let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        nixpkgs-61684d-pkgs = (import nixpkgs-61684d {
          system = "x86_64-linux";
          config.allowUnfree = true;
          config.permittedInsecurePackages = [
          ];
        });
      in
      {
        devShells.x86_64-linux.default = pkgs.mkShell {
          buildInputs = [
            (builtins.trace "downloading rustup@latest" (builtins.fetchClosure {
              
              fromStore = "https://cache.nixos.org";
              fromPath = "/nix/store/17zvb7nfsz9x184ilpygcwrjc4hrcwjr-rustup-1.28.2";
              inputAddressed = true;
            }))
            (builtins.trace "downloading llvm@latest" (builtins.fetchClosure {
              
              fromStore = "https://cache.nixos.org";
              fromPath = "/nix/store/a7nzy012wylfq7qfhhclr4lpq92gsx4j-llvm-11.1.0";
              inputAddressed = true;
            }))
            (builtins.trace "downloading ruff@latest" (builtins.fetchClosure {
              
              fromStore = "https://cache.nixos.org";
              fromPath = "/nix/store/d9qz1r5z8qr9risdad9i12mapw5yqq0x-ruff-0.15.4";
              inputAddressed = true;
            }))
            (builtins.trace "downloading lua-language-server@latest" (builtins.fetchClosure {
              
              fromStore = "https://cache.nixos.org";
              fromPath = "/nix/store/f9vbcd5alz8v11g07v96jwc3z3brdzj9-lua-language-server-3.17.1";
              inputAddressed = true;
            }))
            (builtins.trace "downloading stylua@latest" (builtins.fetchClosure {
              
              fromStore = "https://cache.nixos.org";
              fromPath = "/nix/store/4g8rr257v78kfav5czdxnslpqzi6a23j-stylua-2.3.1";
              inputAddressed = true;
            }))
            (builtins.trace "downloading nodejs_20@latest" (builtins.fetchClosure {
              
              fromStore = "https://cache.nixos.org";
              fromPath = "/nix/store/9fs868i30kqm70753nz8y55n24cvavzh-nodejs-20.20.0";
              inputAddressed = true;
            }))
            (builtins.trace "downloading nodePackages.prettier@latest" (builtins.fetchClosure {
              
              fromStore = "https://cache.nixos.org";
              fromPath = "/nix/store/wry9vlk19pk7izrknb980icc8gihzllx-prettier-3.5.3";
              inputAddressed = true;
            }))
            
            (builtins.trace "downloading go@latest" (builtins.fetchClosure {
              
              fromStore = "https://cache.nixos.org";
              fromPath = "/nix/store/s9dwyyi8mk76wslsm6jl50ky9hd11pv3-go-1.26.0";
              inputAddressed = true;
            }))
            (builtins.trace "downloading gopls@latest" (builtins.fetchClosure {
              
              fromStore = "https://cache.nixos.org";
              fromPath = "/nix/store/673mkzhmbf2syvzbx9kfg85xzw043lk3-gopls-0.21.1";
              inputAddressed = true;
            }))
            (builtins.trace "downloading gofumpt@latest" (builtins.fetchClosure {
              
              fromStore = "https://cache.nixos.org";
              fromPath = "/nix/store/0868kga1asp5qwjf3g9i9f15269w4z8c-gofumpt-0.9.2";
              inputAddressed = true;
            }))
            (builtins.trace "evaluating nixpkgs-61684d-pkgs.nodePackages.typescript-language-server" nixpkgs-61684d-pkgs.nodePackages.typescript-language-server)
          ];
        };
      };
 }
