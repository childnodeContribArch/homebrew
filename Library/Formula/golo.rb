class Golo < Formula
  desc "Lightweight dynamic language for the JVM"
  homepage "http://golo-lang.org"
  url "https://repo1.maven.org/maven2/org/golo-lang/golo/2.1.0/golo-2.1.0-distribution.tar.gz"
  sha256 "59c7324b7eac88dfe2cb9612468cf5639ae0b84e44319b2ee617e0e054eed422"

  devel do
    url "https://www.eclipse.org/downloads/download.php?file=/golo/golo-3.0.0-incubation-M3.zip&r=1"
    sha256 "70a1dbb24901e30b3a75f312be25afc1c4cfe8d69ca9e251153e93491adbd880"
    version "3.0.0-incubation-M3"
    depends_on :java => "1.8+"
  end

  head do
    url "https://github.com/eclipse/golo-lang.git"
    depends_on :java => "1.8+"
  end

  depends_on :java => "1.7+"

  def install
    if build.head?
      system "./gradlew", "installDist"
      libexec.install %w[build/install/golo/bin build/install/golo/docs build/install/golo/lib]
    elsif build.devel?
      libexec.install %w[bin docs lib]
    else
      libexec.install %w[bin doc lib]
    end
    libexec.install %w[share samples]

    rm_f Dir["#{libexec}/bin/*.bat"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    bash_completion.install "#{libexec}/share/shell-completion/golo-bash-completion"
    zsh_completion.install "#{libexec}/share/shell-completion/golo-zsh-completion" => "_golo"
    cp "#{bash_completion}/golo-bash-completion", zsh_completion
  end

  def caveats
    if ENV["SHELL"].include? "zsh"
      <<-EOS.undent
        For ZSH users, please add "golo" in yours plugins in ".zshrc"
      EOS
    end
  end

  test do
    system "#{bin}/golo", "golo", "--files", "#{libexec}/samples/helloworld.golo"
  end
end
