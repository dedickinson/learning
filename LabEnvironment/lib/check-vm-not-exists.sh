if [ "$vm_exists" == "\"$BUILDER_VM\"" ]
then
    echo "A VM with the name '$BUILDER_VM' already exists"
    exit 1
fi