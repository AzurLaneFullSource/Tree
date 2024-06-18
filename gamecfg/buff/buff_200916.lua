return {
	init_effect = "",
	name = "2024偶像活动三期EX 欧根盾（地狱）",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200916,
	last_effect = "",
	effect_list = {
		{
			id = 1,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield02",
				count = 99999,
				bulletType = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_1)
					local var0_1 = arg0_1 * 3

					return Vector3(math.sin(var0_1) * 3, 0.75, math.cos(var0_1) * 3)
				end,
				rotationFun = function(arg0_2)
					return Vector3(0, arg0_2 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
				end
			}
		},
		{
			id = 2,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield02",
				count = 99999,
				bulletType = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_3)
					local var0_3 = arg0_3 * 3 + 1.256

					return Vector3(math.sin(var0_3) * 3, 0.75, math.cos(var0_3) * 3)
				end,
				rotationFun = function(arg0_4)
					return Vector3(0, arg0_4 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 162, 0)
				end
			}
		},
		{
			id = 3,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield02",
				count = 99999,
				bulletType = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_5)
					local var0_5 = arg0_5 * 3 + 2.512

					return Vector3(math.sin(var0_5) * 3, 0.75, math.cos(var0_5) * 3)
				end,
				rotationFun = function(arg0_6)
					return Vector3(0, arg0_6 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
				end
			}
		},
		{
			id = 4,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield02",
				count = 99999,
				bulletType = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_7)
					local var0_7 = arg0_7 * 3 - 1.256

					return Vector3(math.sin(var0_7) * 3, 0.75, math.cos(var0_7) * 3)
				end,
				rotationFun = function(arg0_8)
					return Vector3(0, arg0_8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 18, 0)
				end
			}
		},
		{
			id = 5,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield02",
				count = 99999,
				bulletType = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_9)
					local var0_9 = arg0_9 * 3 - 2.512

					return Vector3(math.sin(var0_9) * 3, 0.75, math.cos(var0_9) * 3)
				end,
				rotationFun = function(arg0_10)
					return Vector3(0, arg0_10 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
				end
			}
		},
		{
			id = 6,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield05",
				count = 99999,
				bulletType = 3,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_11)
					local var0_11 = arg0_11 * -2.4

					return Vector3(math.sin(var0_11) * 5, 0.75, math.cos(var0_11) * 5)
				end,
				rotationFun = function(arg0_12)
					return Vector3(0, arg0_12 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
				end
			}
		},
		{
			id = 7,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield05",
				count = 99999,
				bulletType = 3,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_13)
					local var0_13 = arg0_13 * -2.4 + 0.785

					return Vector3(math.sin(var0_13) * 5, 0.75, math.cos(var0_13) * 5)
				end,
				rotationFun = function(arg0_14)
					return Vector3(0, arg0_14 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 135, 0)
				end
			}
		},
		{
			id = 8,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield05",
				count = 99999,
				bulletType = 3,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_15)
					local var0_15 = arg0_15 * -2.4 + 1.57

					return Vector3(math.sin(var0_15) * 5, 0.75, math.cos(var0_15) * 5)
				end,
				rotationFun = function(arg0_16)
					return Vector3(0, arg0_16 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 180, 0)
				end
			}
		},
		{
			id = 9,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield05",
				count = 99999,
				bulletType = 3,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_17)
					local var0_17 = arg0_17 * -2.4 + 2.355

					return Vector3(math.sin(var0_17) * 5, 0.75, math.cos(var0_17) * 5)
				end,
				rotationFun = function(arg0_18)
					return Vector3(0, arg0_18 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 225, 0)
				end
			}
		},
		{
			id = 10,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield05",
				count = 99999,
				bulletType = 3,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_19)
					local var0_19 = arg0_19 * -2.4 + 3.14

					return Vector3(math.sin(var0_19) * 5, 0.75, math.cos(var0_19) * 5)
				end,
				rotationFun = function(arg0_20)
					return Vector3(0, arg0_20 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 270, 0)
				end
			}
		},
		{
			id = 11,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield05",
				count = 99999,
				bulletType = 3,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_21)
					local var0_21 = arg0_21 * -2.4 + 3.925

					return Vector3(math.sin(var0_21) * 5, 0.75, math.cos(var0_21) * 5)
				end,
				rotationFun = function(arg0_22)
					return Vector3(0, arg0_22 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 315, 0)
				end
			}
		},
		{
			id = 12,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield05",
				count = 99999,
				bulletType = 3,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_23)
					local var0_23 = arg0_23 * -2.4 + 4.71

					return Vector3(math.sin(var0_23) * 5, 0.75, math.cos(var0_23) * 5)
				end,
				rotationFun = function(arg0_24)
					return Vector3(0, arg0_24 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST, 0)
				end
			}
		},
		{
			id = 13,
			type = "BattleBuffShieldWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "shield05",
				count = 99999,
				bulletType = 3,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_25)
					local var0_25 = arg0_25 * -2.4 + 5.495

					return Vector3(math.sin(var0_25) * 5, 0.75, math.cos(var0_25) * 5)
				end,
				rotationFun = function(arg0_26)
					return Vector3(0, arg0_26 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 45, 0)
				end
			}
		},
		{
			id = 14,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 99999,
				effect = "shield06",
				damage = 100,
				attack_attribute = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_27)
					local var0_27 = arg0_27 * 1.5

					return Vector3(math.sin(var0_27) * 8, 0.75, math.cos(var0_27) * 8)
				end,
				rotationFun = function(arg0_28)
					return Vector3(0, arg0_28 * 0.5 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
				end
			}
		},
		{
			id = 15,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 99999,
				effect = "shield06",
				damage = 100,
				attack_attribute = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_29)
					local var0_29 = arg0_29 * 1.5 + 1.04666666666667

					return Vector3(math.sin(var0_29) * 8, 0.75, math.cos(var0_29) * 8)
				end,
				rotationFun = function(arg0_30)
					return Vector3(0, arg0_30 * 0.5 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 150, 0)
				end
			}
		},
		{
			id = 16,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 99999,
				effect = "shield06",
				damage = 100,
				attack_attribute = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_31)
					local var0_31 = arg0_31 * 1.5 + 2.09333333333333

					return Vector3(math.sin(var0_31) * 8, 0.75, math.cos(var0_31) * 8)
				end,
				rotationFun = function(arg0_32)
					return Vector3(0, arg0_32 * 0.5 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
				end
			}
		},
		{
			id = 17,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 99999,
				effect = "shield06",
				damage = 100,
				attack_attribute = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_33)
					local var0_33 = arg0_33 * 1.5 + 3.14

					return Vector3(math.sin(var0_33) * 8, 0.75, math.cos(var0_33) * 8)
				end,
				rotationFun = function(arg0_34)
					return Vector3(0, arg0_34 * 0.5 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 270, 0)
				end
			}
		},
		{
			id = 18,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 99999,
				effect = "shield06",
				damage = 100,
				attack_attribute = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_35)
					local var0_35 = arg0_35 * 1.5 + 4.18666666666667

					return Vector3(math.sin(var0_35) * 8, 0.75, math.cos(var0_35) * 8)
				end,
				rotationFun = function(arg0_36)
					return Vector3(0, arg0_36 * 0.5 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 330, 0)
				end
			}
		},
		{
			id = 19,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 99999,
				effect = "shield06",
				damage = 100,
				attack_attribute = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							1.02,
							0,
							1.22
						}
					}
				},
				centerPosFun = function(arg0_37)
					local var0_37 = arg0_37 * 1.5 + 5.23333333333333

					return Vector3(math.sin(var0_37) * 8, 0.75, math.cos(var0_37) * 8)
				end,
				rotationFun = function(arg0_38)
					return Vector3(0, arg0_38 * 0.5 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 30, 0)
				end
			}
		}
	}
}
