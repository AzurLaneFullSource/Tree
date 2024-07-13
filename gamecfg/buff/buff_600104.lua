return {
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
				count = 70,
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
				count = 70,
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
				count = 70,
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
				count = 70,
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
				count = 70,
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
			type = "BattleBuffCastSkill",
			trigger = {
				"onShieldBroken"
			},
			arg_list = {
				skill_id = 600102,
				shieldBuffID = 600104
			}
		}
	},
	{
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
					count = 30,
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
					centerPosFun = function(arg0_11)
						local var0_11 = arg0_11 * 3

						return Vector3(math.sin(var0_11) * 3, 0.75, math.cos(var0_11) * 3)
					end,
					rotationFun = function(arg0_12)
						return Vector3(0, arg0_12 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
					count = 30,
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
					centerPosFun = function(arg0_13)
						local var0_13 = arg0_13 * 3 + 1.256

						return Vector3(math.sin(var0_13) * 3, 0.75, math.cos(var0_13) * 3)
					end,
					rotationFun = function(arg0_14)
						return Vector3(0, arg0_14 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 162, 0)
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
					count = 30,
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
					centerPosFun = function(arg0_15)
						local var0_15 = arg0_15 * 3 + 2.512

						return Vector3(math.sin(var0_15) * 3, 0.75, math.cos(var0_15) * 3)
					end,
					rotationFun = function(arg0_16)
						return Vector3(0, arg0_16 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
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
					count = 30,
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
					centerPosFun = function(arg0_17)
						local var0_17 = arg0_17 * 3 - 1.256

						return Vector3(math.sin(var0_17) * 3, 0.75, math.cos(var0_17) * 3)
					end,
					rotationFun = function(arg0_18)
						return Vector3(0, arg0_18 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 18, 0)
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
					count = 30,
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
					centerPosFun = function(arg0_19)
						local var0_19 = arg0_19 * 3 - 2.512

						return Vector3(math.sin(var0_19) * 3, 0.75, math.cos(var0_19) * 3)
					end,
					rotationFun = function(arg0_20)
						return Vector3(0, arg0_20 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onShieldBroken"
				},
				arg_list = {
					skill_id = 600102,
					shieldBuffID = 600104
				}
			}
		}
	},
	{
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
					count = 50,
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
					centerPosFun = function(arg0_21)
						local var0_21 = arg0_21 * 3

						return Vector3(math.sin(var0_21) * 3, 0.75, math.cos(var0_21) * 3)
					end,
					rotationFun = function(arg0_22)
						return Vector3(0, arg0_22 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
					count = 50,
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
					centerPosFun = function(arg0_23)
						local var0_23 = arg0_23 * 3 + 1.256

						return Vector3(math.sin(var0_23) * 3, 0.75, math.cos(var0_23) * 3)
					end,
					rotationFun = function(arg0_24)
						return Vector3(0, arg0_24 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 162, 0)
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
					count = 50,
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
					centerPosFun = function(arg0_25)
						local var0_25 = arg0_25 * 3 + 2.512

						return Vector3(math.sin(var0_25) * 3, 0.75, math.cos(var0_25) * 3)
					end,
					rotationFun = function(arg0_26)
						return Vector3(0, arg0_26 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
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
					count = 50,
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
					centerPosFun = function(arg0_27)
						local var0_27 = arg0_27 * 3 - 1.256

						return Vector3(math.sin(var0_27) * 3, 0.75, math.cos(var0_27) * 3)
					end,
					rotationFun = function(arg0_28)
						return Vector3(0, arg0_28 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 18, 0)
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
					count = 50,
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
					centerPosFun = function(arg0_29)
						local var0_29 = arg0_29 * 3 - 2.512

						return Vector3(math.sin(var0_29) * 3, 0.75, math.cos(var0_29) * 3)
					end,
					rotationFun = function(arg0_30)
						return Vector3(0, arg0_30 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onShieldBroken"
				},
				arg_list = {
					skill_id = 600102,
					shieldBuffID = 600104
				}
			}
		}
	},
	{
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
					count = 70,
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
					centerPosFun = function(arg0_31)
						local var0_31 = arg0_31 * 3

						return Vector3(math.sin(var0_31) * 3, 0.75, math.cos(var0_31) * 3)
					end,
					rotationFun = function(arg0_32)
						return Vector3(0, arg0_32 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
					count = 70,
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
					centerPosFun = function(arg0_33)
						local var0_33 = arg0_33 * 3 + 1.256

						return Vector3(math.sin(var0_33) * 3, 0.75, math.cos(var0_33) * 3)
					end,
					rotationFun = function(arg0_34)
						return Vector3(0, arg0_34 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 162, 0)
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
					count = 70,
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
					centerPosFun = function(arg0_35)
						local var0_35 = arg0_35 * 3 + 2.512

						return Vector3(math.sin(var0_35) * 3, 0.75, math.cos(var0_35) * 3)
					end,
					rotationFun = function(arg0_36)
						return Vector3(0, arg0_36 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
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
					count = 70,
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
					centerPosFun = function(arg0_37)
						local var0_37 = arg0_37 * 3 - 1.256

						return Vector3(math.sin(var0_37) * 3, 0.75, math.cos(var0_37) * 3)
					end,
					rotationFun = function(arg0_38)
						return Vector3(0, arg0_38 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 18, 0)
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
					count = 70,
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
					centerPosFun = function(arg0_39)
						local var0_39 = arg0_39 * 3 - 2.512

						return Vector3(math.sin(var0_39) * 3, 0.75, math.cos(var0_39) * 3)
					end,
					rotationFun = function(arg0_40)
						return Vector3(0, arg0_40 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onShieldBroken"
				},
				arg_list = {
					skill_id = 600102,
					shieldBuffID = 600104
				}
			}
		}
	},
	{},
	{},
	{},
	{},
	{},
	{},
	{},
	time = 0,
	name = "",
	init_effect = "",
	stack = 1,
	id = 600104,
	picture = "",
	last_effect = "",
	desc = ""
}
