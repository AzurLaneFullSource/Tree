pg = pg or {}
pg.pay_level_award = rawget(pg, "pay_level_award") or setmetatable({
	__name = "pay_level_award"
}, confNEO)
pg.pay_level_award.__namecode__ = true
pg.pay_level_award.all = {
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	12,
	13,
	14,
	15,
	16,
	17,
	18,
	19,
	20,
	21,
	22,
	23,
	24,
	25
}
pg.base = pg.base or {}
pg.base.pay_level_award = {}

;(function()
	pg.base.pay_level_award[1] = {
		exp = 6,
		cv_key = "shop1",
		level = 1,
		dialog = "Welcome, welcome, *Nyaa~*!"
	}
	pg.base.pay_level_award[2] = {
		exp = 15,
		cv_key = "shop2",
		level = 2,
		dialog = "*Purr*, *Nyaa~*?"
	}
	pg.base.pay_level_award[3] = {
		exp = 30,
		cv_key = "shop3",
		level = 3,
		dialog = "Thanks for your patronage, *Nyaa~*!"
	}
	pg.base.pay_level_award[4] = {
		exp = 60,
		cv_key = "",
		level = 4,
		dialog = "Lots of good stuff today, Commander~! Don't miss out, *Nyaa~*!"
	}
	pg.base.pay_level_award[5] = {
		exp = 100,
		cv_key = "shop4",
		level = 5,
		dialog = "Commander, you're busy, *Nyaa~*?"
	}
	pg.base.pay_level_award[6] = {
		exp = 150,
		cv_key = "",
		level = 6,
		dialog = "{namecode:98} is busy, *Nyaa~*, and doesn't have time to play with Commander, *Nyaa~*..."
	}
	pg.base.pay_level_award[7] = {
		exp = 200,
		cv_key = "shop7",
		level = 7,
		dialog = "Do you want to be 'repaired' by {namecode:98}, Commander?"
	}
	pg.base.pay_level_award[8] = {
		exp = 250,
		cv_key = "",
		level = 8,
		dialog = "*Nyaa~*?! Commander... you want to buy something, *Nyaa~*?"
	}
	pg.base.pay_level_award[9] = {
		exp = 300,
		cv_key = "shop9",
		level = 9,
		dialog = "You'll even touch {namecode:98}'s ears, *Nyaa~*..."
	}
	pg.base.pay_level_award[10] = {
		exp = 350,
		cv_key = "shop10",
		level = 10,
		dialog = "*Nyaa~?* Commander here to see {namecode:98} again?"
	}
	pg.base.pay_level_award[11] = {
		exp = 400,
		cv_key = "",
		level = 11,
		dialog = "It'd make {namecode:98} happy if you took a look at something to buy... *Nyaa~*..."
	}
	pg.base.pay_level_award[12] = {
		exp = 450,
		cv_key = "shop12",
		level = 12,
		dialog = "{namecode:98} isn't a pet, *Nyaa~*!"
	}
	pg.base.pay_level_award[13] = {
		exp = 500,
		cv_key = "",
		level = 13,
		dialog = "Watch out for weird gear, you might get hurt, *Nyaa~*!"
	}
	pg.base.pay_level_award[14] = {
		exp = 550,
		cv_key = "shop14",
		level = 14,
		dialog = "I.. I... not happy... *Nyaa~*..."
	}
	pg.base.pay_level_award[15] = {
		exp = 600,
		cv_key = "",
		level = 15,
		dialog = "*Purr*, *Nyaa~*? Commander, touching fish again, *Nyaa~*? Buy something or I'm going to report you, *Nyaa~*!"
	}
	pg.base.pay_level_award[16] = {
		exp = 650,
		cv_key = "",
		level = 16,
		dialog = "{namecode:98} is pretty tired..."
	}
	pg.base.pay_level_award[17] = {
		exp = 700,
		cv_key = "shop17",
		level = 17,
		dialog = "Is this... romance, *Nyaa~*?"
	}
	pg.base.pay_level_award[18] = {
		exp = 800,
		cv_key = "shop18",
		level = 18,
		dialog = "Come and see me when you can, *Nyaa~*!"
	}
	pg.base.pay_level_award[19] = {
		exp = 900,
		cv_key = "",
		level = 19,
		dialog = "Commander, what's up? Want {namecode:98} to inspect you?"
	}
	pg.base.pay_level_award[20] = {
		exp = 1000,
		cv_key = "",
		level = 20,
		dialog = "*Purr... purr... Nyaa~...*"
	}
	pg.base.pay_level_award[21] = {
		exp = 1100,
		cv_key = "shop21",
		level = 21,
		dialog = "Well... it's not like you get a discount, *Nyaa~*!"
	}
	pg.base.pay_level_award[22] = {
		exp = 1200,
		cv_key = "shop22",
		level = 22,
		dialog = "*Nyaa...~* Ha!! So, so comfortable. You almost got away with it, *Nyaa~*!"
	}
	pg.base.pay_level_award[23] = {
		exp = 1300,
		cv_key = "",
		level = 23,
		dialog = "Eyes, head... so dizzy... *Nyaa~*..."
	}
	pg.base.pay_level_award[24] = {
		exp = 1400,
		cv_key = "",
		level = 24,
		dialog = "Commander... you smell good... *purr*..."
	}
	pg.base.pay_level_award[25] = {
		exp = 1500,
		cv_key = "shop25",
		level = 25,
		dialog = "You're the best, Commander. *Nyaa~*!"
	}
end)()
