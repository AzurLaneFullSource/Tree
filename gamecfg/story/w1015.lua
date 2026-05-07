return {
	id = "W1015",
	mode = 2,
	skipTip = false,
	once = true,
	scripts = {
		{
			dir = 1,
			side = 2,
			option_force_center = true,
			say = "By expending certain items, you might be able to discover hidden investigation points in the area...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			painting = {
				alpha = 0.3,
				time = 1
			},
			options = {
				{
					content = "Use 1 Energy Storage Device to locate hidden enemies.",
					flag = 2
				},
				{
					content = "Use 2 Special Item Tokens to locate hidden supplies.",
					flag = 1
				},
				{
					content = "Repeatedly scans to find hidden enemies. Consumes 1 Energy Storage Device per scan.",
					flag = 4
				},
				{
					content = "Repeatedly scans to find hidden supplies. Consumes 2 Special Item Tokens per scan.",
					flag = 3
				},
				{
					content = "Leave",
					flag = 0
				}
			}
		}
	}
}
