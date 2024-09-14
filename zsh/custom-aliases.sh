# Clean embroider build artifacts
alias clean-embroider="rm -rf $TMPDIR/embroider"

# yalc add and clean embroider 
alias yalc-embroider="yalc add $1 && clean-embroider"

# yalc add and clean embroider then install fresh modules with pnpm and run the app
alias yalc-embroider-run="yalc add $1 && rm -rf $TMPDIR/embroider && pnpm i && pnpm run start"

#check process on port and kills it 
killport() {
    lsof -ti :"$1" | xargs kill -9
}
