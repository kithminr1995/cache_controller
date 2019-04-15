module Comparator (
							Tag1,
							Tag2, 
							Match
							); 
							
input [`TAG] Tag1; 
input [`TAG] Tag2; 
output Match; 

wire Match = (Tag1 == Tag2);

endmodule