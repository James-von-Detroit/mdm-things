PKGTITLE="trend-mdm-scripts"
PKGVERSION="1.0.0"
PKGID=com.trendph.mdm.scripts
PROJECT="trend-mdm-scripts"

#################################################

##Help - Show this help menu
help: 
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

##  clean - Clean up temporary working directories
clean:
	rm -f ./outset*.pkg
	rm -f ./pkgroot/usr/local/outset/*/*.pyc

##  pkg - Create a package using pkgbuild
pkg: clean
	pkgbuild --root pkgroot --identifier ${PKGID} --version ${PKGVERSION} --ownership recommended ./${PKGTITLE}-${PKGVERSION}.pkg
