#!/bin/bash
user=Spiral # Change this

echo "Enter source address: "
read srcaddr


total=$(cat /home/$user/.passwd | sudo -S docker exec zen-node gosu user zen-cli z_getbalance $srcaddr)
printf "\nFunds on address: $total\n\n"

echo "Are all outputs the same amount? (y/n)"
read same

amt=""
addr="ignore"

if [[ $same == y* ]] || [[ $same == Y* ]]; then
    printf "\nEnter amount to send to each address:\n"
    read amt
    # Format amt to ensure leading 0
    amt=$(echo $amt | sed 's/^\./0./')
fi

printf "\nEnter an empty address to finish.\n\n"
if [ ! -z "$amt" ]; then
    while [ ! -z "$addr" ]; do
        echo "Enter address:"
        read addr
        addrlist[${#addrlist[@]}]=$addr
        amtlist[${#amtlist[@]}]=$amt
        # The final read will store the empty variable
    done
else
    while [ ! -z "$addr" ]; do
        printf "\nEnter address:"
        read addr
        addrlist[${#addrlist[@]}]=$addr

        if [ ! -z "$addr" ]; then
            printf "\nEnter amount:\n"
            read amt
            amt=$(echo $amt | sed 's/^\./0./')
            amtlist[${#amtlist[@]}]=$amt
        fi
    done
fi

cmdstr="cat /home/$user/.passwd | sudo -S docker exec zen-node gosu user zen-cli z_sendmany \
\"$srcaddr\" '["

printf "Please review the transaction:\n\n"

printf "Source address:\n$srcaddr\n\n"

printf "Outputs:\n--------\n"

i=0
sendamt=0
while [ "$i" -lt $((${#addrlist[@]}-1)) ]; do
    printf "Address:\n${addrlist[$i]}\nAmount:\n${amtlist[$i]}\n\n"
    sendamt=$(echo "$sendamt + ${amtlist[$i]}" | bc)
    cmdstr+="{\"amount\": ${amtlist[$i]}, \"address\": \"${addrlist[$i]}\"},"
    ((i++))
done

printf "Source funds: $total\n"
printf "Total send amount: $sendamt\n\n"

if [ $(echo "$sendamt > $total - 0.0001" | bc) -eq 1 ]; then
    echo "Error: Send amount + tx fee is greater than total!"
    exit 1
fi

remainder=$(echo "$total - $sendamt - 0.0001" | bc | sed 's/^\./0./')

if [ $(echo "$remainder > 0" | bc) -eq 1 ]; then
    echo "Sending remainder: $remainder back to source address: $srcaddr"
    cmdstr+="{\"amount\": $remainder, \"address\": \"$srcaddr\"}"
else
    # Trim off last comma
    cmdstr=${cmdstr:0:$((${#cmdstr}-1))}
fi

# Close the command
cmdstr+="]'"


printf "\n$cmdstr\n\n"


echo "Approve transaction? (y/n)"
read approval

if [[ $approval == y* ]] || [[ $approval == Y* ]]; then
    eval $cmdstr
fi
