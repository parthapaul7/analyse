#!/bin/bash
# Original structure file
input_file="POSCAR"

# Function to increment the cell length values
increment_cell_length() {
    local input_value=$1
    local increment=$2
    local factor=$3
    awk -v val="$input_value" -v inc="$increment" -v fac="$factor" 'BEGIN { printf "%.10f", val + inc * fac }'
}

# Loop to create 5 new structure files with incremented cell lengths
for ((i=-5; i<13; i++)); do
    # Calculate new cell lengths
    new_cell_len11=$(increment_cell_length 1.3893840312921046 $(echo "0.05*$i " | bc) 1.3893840312921046 )
    new_cell_len12=$(increment_cell_length 0.8021612444742640 $(echo "0.05*$i " | bc) 0.8021612444742640 )
    new_cell_len13=$(increment_cell_length 8.3478527068999995 $(echo "0.05*$i " | bc) 8.3478527068999995 )
    new_cell_len21=$(increment_cell_length -1.3893840312921046 $(echo "0.05*$i " | bc) -1.3893840312921046 )
    new_cell_len22=$(increment_cell_length 0.8021612444742640 $(echo "0.05*$i " | bc) 0.8021612444742640 )
    new_cell_len23=$(increment_cell_length 8.3478527068999995 $(echo "0.05*$i " | bc) 8.3478527068999995 )
    new_cell_len31=$(increment_cell_length 0.0000000000000000 $(echo "0.05*$i " | bc) 0.000000000000000  )
    new_cell_len32=$(increment_cell_length -1.6043224889485279 $(echo "0.05*$i " | bc) -1.6043224889485279 )
    new_cell_len33=$(increment_cell_length 8.3478527068999995 $(echo "0.05*$i " | bc) 8.3478527068999995 )
    
    # Create new structure file with incremented cell lengths
    output_file="POSCAR$i"

    # Ensure Unix-style line endings by using `awk` and formatting consistently
    awk -v new_cell_len11="$new_cell_len11" \
        -v new_cell_len12="$new_cell_len12" \
        -v new_cell_len13="$new_cell_len13" \
        -v new_cell_len21="$new_cell_len21" \
        -v new_cell_len22="$new_cell_len22" \
        -v new_cell_len23="$new_cell_len23" \
        -v new_cell_len31="$new_cell_len31" \
        -v new_cell_len32="$new_cell_len32" \
        -v new_cell_len33="$new_cell_len33" \
        'BEGIN { OFS=" " }
         {
            if (NR == 3) {
                printf "%18.10f %18.10f %18.10f\n", new_cell_len11, new_cell_len12, new_cell_len13 
            } else if (NR == 4) {
                printf "%18.10f %18.10f %18.10f\n", new_cell_len21, new_cell_len22, new_cell_len23
            } else if (NR == 5){     
		printf "%18.10f %18.10f %18.10f\n", new_cell_len31, new_cell_len32 , new_cell_len33
            } else {
                print
            }
         }' "$input_file" | tr -d '\r' > "$output_file"

    echo "Created $output_file with new cell lengths: $new_cell_length, $new_cell_len11, $new_cell_len22"
done

