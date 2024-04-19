# make lists of actual and current eslint rules
mapfile -td $'\n' actual < <(find ~/node_modules/eslint/lib/rules/ -maxdepth 1 -type f | sed 's#.*/##' | sed 's#.js$##')
rules_start_idx=$(awk '/rules/ {print NR}' eslint.config.js)
rules_string=$(sed -n "$rules_start_idx,\$p" <eslint.config.js)
current_output=$(echo "{$rules_string" | jq -r '.rules | keys | @sh')
declare -a current="($current_output)"

# check every actual rule for deprecation
deprecated_present=("index")
for rule in "${actual[@]}";do
    output=$(rg "deprecated: true" "$HOME/node_modules/eslint/lib/rules/$rule.js")
    if [ -n "$output" ];then
        deprecated_present+=("$rule")
    fi
done

# add all non-deprecated ones to the eslint config
mapfile -td $'\n' new_rules < <(comm -2 -3 <(printf "%s\n" "${actual[@]}" | LC_ALL=C sort) <(printf "%s\n" "${current[@]}" | LC_ALL=C sort))
for rule in "${new_rules[@]}";do
    if echo "${deprecated_present[@]}" | grep -vwq "$rule";then
        echo "adding new rule $rule"
        rules_string=$(sed -n "$rules_start_idx,\$p" <eslint.config.js)
        head -n "$rules_start_idx" eslint.config.js > TMP
        head -n -1 TMP > eslint.config.js
        echo "{$rules_string" | jq -r --indent 4 -S ".rules |= . + {\"$rule\": \"error\"}" > TMP
        tail -n +2 TMP >> eslint.config.js
        rm TMP
    fi
done

# check the config for base eslint rules that are no longer present
mapfile -td $'\n' old_rules < <(comm -1 -3 <(printf "%s\n" "${actual[@]}" | LC_ALL=C sort) <(printf "%s\n" "${current[@]}" | LC_ALL=C sort))
for rule in "${old_rules[@]}";do
    if [[ "$rule" != padding-lines/* && "$rule" != jsdoc/* && "$rule" != "sort-keys/sort-keys-fix" ]];then
        echo "$rule is no longer valid"
    fi
done

# make a list of jsdoc rules
mapfile -td $'\n' jsdoc_rules_pascal < <(find ~/node_modules/eslint-plugin-jsdoc/dist/rules/*.cjs -maxdepth 1 -type f | sed 's#.*/##' | sed 's#.cjs$##')
jsdoc_rules=()
for rule in "${jsdoc_rules_pascal[@]}";do
    kebab_case=$(echo "jsdoc/$rule" | sed -r 's/([a-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')
    jsdoc_rules+=("$kebab_case")
done

# check the config for jsdoc rules no longer present
for rule in "${old_rules[@]}";do
    if [[ "$rule" == jsdoc/* ]];then
        if echo "${jsdoc_rules[@]}" | grep -vwq "$rule";then
            echo "$rule is no longer valid"
        fi
    fi
done

# add all non-deprecated ones to the eslint config
mapfile -td $'\n' new_rules < <(comm -2 -3 <(printf "%s\n" "${jsdoc_rules[@]}" | LC_ALL=C sort) <(printf "%s\n" "${current[@]}" | LC_ALL=C sort))
for rule in "${new_rules[@]}";do
    echo "adding new rule $rule"
    rules_string=$(sed -n "$rules_start_idx,\$p" <eslint.config.js)
    head -n "$rules_start_idx" eslint.config.js > TMP
    head -n -1 TMP > eslint.config.js
    echo "{$rules_string" | jq -r --indent 4 -S ".rules |= . + {\"$rule\": \"error\"}" > TMP
    tail -n +2 TMP >> eslint.config.js
    rm TMP
done

# check the config for rule that are deprecated
for rule in "${current[@]}";do
    output=$(rg "deprecated: true" "$HOME/node_modules/eslint/lib/rules/$rule.js" 2>/dev/null)
    if [ -n "$output" ];then
        echo "$rule is deprecated"
    fi
done
