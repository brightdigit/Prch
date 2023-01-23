#!/bin/sh

SomeErrorHandler () {
	(( errcount++ ))       # or (( errcount += $? ))
}

if [ -z "$SRCROOT" ]; then
	SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
	PACKAGE_DIR="${SCRIPT_DIR}/.."
else
	PACKAGE_DIR="${SRCROOT}/Packages/FloxBxKit" 	
fi

if [ -z "$GITHUB_ACTION" ]; then
	MINT_CMD="/opt/homebrew/bin/mint"
else
	MINT_CMD="mint"
	trap SomeErrorHandler ERR
	LINT_MODE="STRICT"
fi

export MINT_PATH="$PACKAGE_DIR/.mint"
MINT_ARGS="-n -m $PACKAGE_DIR/Mintfile --silent"
MINT_RUN="$MINT_CMD run $MINT_ARGS"

pushd $PACKAGE_DIR

$MINT_CMD bootstrap -m Mintfile

if [ "$LINT_MODE" == "NONE" ]; then
	exit
elif [ "$LINT_MODE" == "STRICT" ]; then
	SWIFTFORMAT_OPTIONS=""
	SWIFTLINT_OPTIONS="--strict"
	STRINGSLINT_OPTIONS="--config .strict.stringslint.yml"
else 
	SWIFTFORMAT_OPTIONS=""
	SWIFTLINT_OPTIONS=""
	STRINGSLINT_OPTIONS="--config .stringslint.yml"
fi

pushd $PACKAGE_DIR

if [ -z "$CI" ]; then
	$MINT_RUN swiftformat .
	$MINT_RUN swiftlint autocorrect
fi

# Too Many False Positives
# $MINT_RUN periphery scan 
# $MINT_RUN stringslint lint $STRINGSLINT_OPTIONS
$MINT_RUN swiftformat --lint $SWIFTFORMAT_OPTIONS .
$MINT_RUN swiftlint lint $SWIFTLINT_OPTIONS

popd

if  [ $errcount > 0 ]; then
	echo "Too many errors"
	exit $errcount
fi
