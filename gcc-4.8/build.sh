ln -s $PREFIX/lib $PREFIX/lib64

if [ "$(uname)" == "Darwin" ]; then
    export LDFLAGS="-Wl,-headerpad_max_install_names"
    export BOOT_LDFLAGS="-Wl,-headerpad_max_install_names"

    ./configure \
        --prefix=$PREFIX \
        --libdir=$PREFIX/lib \
        --with-gmp=$PREFIX \
        --with-mpfr=$PREFIX \
        --with-mpc=$PREFIX \
        --with-isl=$PREFIX \
        --with-cloog=$PREFIX \
        --with-boot-ldflags=$LDFLAGS \
        --with-stage1-ldflags=$LDFLAGS \
        --disable-multilib
else
    ./configure \
        --prefix=$PREFIX \
        --libdir=$PREFIX/lib \
        --with-gmp=$PREFIX \
        --with-mpfr=$PREFIX \
        --with-mpc=$PREFIX \
        --with-isl=$PREFIX \
        --with-cloog=$PREFIX \
        --disable-multilib
fi
make -j$CPU_COUNT
make install
rm $PREFIX/lib64

# Link cc to gcc
(cd $PREFIX/bin && ln -s gcc cc)

# For reference during post-link.sh, record some
# details about the OS this binary was produced with.
mkdir -p ${PREFIX}/share
cat /etc/*-release > ${PREFIX}/share/conda-gcc-build-machine-os-details
