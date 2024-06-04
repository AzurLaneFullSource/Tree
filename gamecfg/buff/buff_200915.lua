return {
	init_effect = "",
	name = "2024偶像活动三期EX 欧根盾（普通）",
	time = 0,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 200915,
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
				count = 60,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 3

					return Vector3(math.sin(var0) * 3, 0.75, math.cos(var0) * 3)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
				count = 60,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 3 + 1.256

					return Vector3(math.sin(var0) * 3, 0.75, math.cos(var0) * 3)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 162, 0)
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
				count = 60,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 3 + 2.512

					return Vector3(math.sin(var0) * 3, 0.75, math.cos(var0) * 3)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
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
				count = 60,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 3 - 1.256

					return Vector3(math.sin(var0) * 3, 0.75, math.cos(var0) * 3)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 18, 0)
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
				count = 60,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 3 - 2.512

					return Vector3(math.sin(var0) * 3, 0.75, math.cos(var0) * 3)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
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
				count = 10,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * -2.4

					return Vector3(math.sin(var0) * 5, 0.75, math.cos(var0) * 5)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
				count = 10,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * -2.4 + 0.785

					return Vector3(math.sin(var0) * 5, 0.75, math.cos(var0) * 5)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 135, 0)
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
				count = 10,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * -2.4 + 1.57

					return Vector3(math.sin(var0) * 5, 0.75, math.cos(var0) * 5)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 180, 0)
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
				count = 10,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * -2.4 + 2.355

					return Vector3(math.sin(var0) * 5, 0.75, math.cos(var0) * 5)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 225, 0)
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
				count = 10,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * -2.4 + 3.14

					return Vector3(math.sin(var0) * 5, 0.75, math.cos(var0) * 5)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 270, 0)
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
				count = 10,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * -2.4 + 3.925

					return Vector3(math.sin(var0) * 5, 0.75, math.cos(var0) * 5)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 315, 0)
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
				count = 10,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * -2.4 + 4.71

					return Vector3(math.sin(var0) * 5, 0.75, math.cos(var0) * 5)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST, 0)
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
				count = 10,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * -2.4 + 5.495

					return Vector3(math.sin(var0) * 5, 0.75, math.cos(var0) * 5)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * -0.8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 45, 0)
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
				count = 10,
				effect = "shield06",
				damage = 12,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 1.5

					return Vector3(math.sin(var0) * 8, 0.75, math.cos(var0) * 8)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * 0.5 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
				count = 10,
				effect = "shield06",
				damage = 12,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 1.5 + 1.04666666666667

					return Vector3(math.sin(var0) * 8, 0.75, math.cos(var0) * 8)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * 0.5 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 150, 0)
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
				count = 10,
				effect = "shield06",
				damage = 12,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 1.5 + 2.09333333333333

					return Vector3(math.sin(var0) * 8, 0.75, math.cos(var0) * 8)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * 0.5 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
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
				count = 10,
				effect = "shield06",
				damage = 12,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 1.5 + 3.14

					return Vector3(math.sin(var0) * 8, 0.75, math.cos(var0) * 8)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * 0.5 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 270, 0)
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
				count = 10,
				effect = "shield06",
				damage = 12,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 1.5 + 4.18666666666667

					return Vector3(math.sin(var0) * 8, 0.75, math.cos(var0) * 8)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * 0.5 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 330, 0)
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
				count = 10,
				effect = "shield06",
				damage = 12,
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
				centerPosFun = function(arg0)
					local var0 = arg0 * 1.5 + 5.23333333333333

					return Vector3(math.sin(var0) * 8, 0.75, math.cos(var0) * 8)
				end,
				rotationFun = function(arg0)
					return Vector3(0, arg0 * 0.5 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 30, 0)
				end
			}
		}
	}
}
