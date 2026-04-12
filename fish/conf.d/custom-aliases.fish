function killport
    lsof -ti :$argv[1] | xargs kill -9
end
