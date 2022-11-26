MATCH n=(start:Address{address:'bc1qhekuaxsq7ps2w7fzw9qwun2x2yacsd6ev4csf6'})-[*]-(end:Address) 
RETURN n 

MATCH n=(start:Address{address:'bc1qhekuaxsq7ps2w7fzw9qwun2x2yacsd6ev4csf6'})-[*]-(end:Address{address:'3NmuUsUNAbnuGoSTR47sJ3YLD1q7tc7YxC'}) 
RETURN n 

MATCH p= (start_output:Output)-[*]-(end_output:Output)
RETURN p
LIMIT 5