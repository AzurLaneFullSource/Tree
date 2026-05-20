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
				effect = "shield05",
				count = 2,
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
				effect = "shield05",
				count = 2,
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
				centerPosFun = function(arg0_3)
					local var0_3 = arg0_3 * 3 + 2.512

					return Vector3(math.sin(var0_3) * 3, 0.75, math.cos(var0_3) * 3)
				end,
				rotationFun = function(arg0_4)
					return Vector3(0, arg0_4 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
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
				effect = "shield05",
				count = 2,
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
				centerPosFun = function(arg0_5)
					local var0_5 = arg0_5 * 3 - 2.512

					return Vector3(math.sin(var0_5) * 3, 0.75, math.cos(var0_5) * 3)
				end,
				rotationFun = function(arg0_6)
					return Vector3(0, arg0_6 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
				end
			}
		},
		{
			id = 4,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 6,
				effect = "shield06",
				damage = 55,
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
				centerPosFun = function(arg0_7)
					local var0_7 = arg0_7 * 3

					return Vector3(math.sin(var0_7) * 8, 0.75, math.cos(var0_7) * 8)
				end,
				rotationFun = function(arg0_8)
					return Vector3(0, arg0_8 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
				end
			}
		},
		{
			id = 5,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 6,
				effect = "shield06",
				damage = 55,
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
				centerPosFun = function(arg0_9)
					local var0_9 = arg0_9 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

					return Vector3(math.sin(var0_9) * 8, 0.75, math.cos(var0_9) * 8)
				end,
				rotationFun = function(arg0_10)
					return Vector3(0, arg0_10 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
				end
			}
		},
		{
			id = 6,
			type = "BattleBuffDamageWall",
			trigger = {
				"onStack",
				"onUpdate"
			},
			arg_list = {
				count = 6,
				effect = "shield06",
				damage = 55,
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
				centerPosFun = function(arg0_11)
					local var0_11 = arg0_11 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

					return Vector3(math.sin(var0_11) * 8, 0.75, math.cos(var0_11) * 8)
				end,
				rotationFun = function(arg0_12)
					return Vector3(0, arg0_12 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
				end
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
					effect = "shield05",
					count = 2,
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
						local var0_13 = arg0_13 * 3

						return Vector3(math.sin(var0_13) * 3, 0.75, math.cos(var0_13) * 3)
					end,
					rotationFun = function(arg0_14)
						return Vector3(0, arg0_14 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
					effect = "shield05",
					count = 2,
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
						local var0_15 = arg0_15 * 3 + 2.512

						return Vector3(math.sin(var0_15) * 3, 0.75, math.cos(var0_15) * 3)
					end,
					rotationFun = function(arg0_16)
						return Vector3(0, arg0_16 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
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
					effect = "shield05",
					count = 2,
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
						local var0_17 = arg0_17 * 3 - 2.512

						return Vector3(math.sin(var0_17) * 3, 0.75, math.cos(var0_17) * 3)
					end,
					rotationFun = function(arg0_18)
						return Vector3(0, arg0_18 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 55,
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
					centerPosFun = function(arg0_19)
						local var0_19 = arg0_19 * 3

						return Vector3(math.sin(var0_19) * 8, 0.75, math.cos(var0_19) * 8)
					end,
					rotationFun = function(arg0_20)
						return Vector3(0, arg0_20 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 55,
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
					centerPosFun = function(arg0_21)
						local var0_21 = arg0_21 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(var0_21) * 8, 0.75, math.cos(var0_21) * 8)
					end,
					rotationFun = function(arg0_22)
						return Vector3(0, arg0_22 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 55,
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
					centerPosFun = function(arg0_23)
						local var0_23 = arg0_23 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(var0_23) * 8, 0.75, math.cos(var0_23) * 8)
					end,
					rotationFun = function(arg0_24)
						return Vector3(0, arg0_24 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
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
					effect = "shield05",
					count = 2,
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
						local var0_25 = arg0_25 * 3

						return Vector3(math.sin(var0_25) * 3, 0.75, math.cos(var0_25) * 3)
					end,
					rotationFun = function(arg0_26)
						return Vector3(0, arg0_26 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_27)
						local var0_27 = arg0_27 * 3 + 2.512

						return Vector3(math.sin(var0_27) * 3, 0.75, math.cos(var0_27) * 3)
					end,
					rotationFun = function(arg0_28)
						return Vector3(0, arg0_28 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
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
					effect = "shield05",
					count = 2,
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
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 60,
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
						local var0_31 = arg0_31 * 3

						return Vector3(math.sin(var0_31) * 8, 0.75, math.cos(var0_31) * 8)
					end,
					rotationFun = function(arg0_32)
						return Vector3(0, arg0_32 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 60,
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
						local var0_33 = arg0_33 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(var0_33) * 8, 0.75, math.cos(var0_33) * 8)
					end,
					rotationFun = function(arg0_34)
						return Vector3(0, arg0_34 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 60,
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
						local var0_35 = arg0_35 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(var0_35) * 8, 0.75, math.cos(var0_35) * 8)
					end,
					rotationFun = function(arg0_36)
						return Vector3(0, arg0_36 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_37)
						local var0_37 = arg0_37 * 3

						return Vector3(math.sin(var0_37) * 3, 0.75, math.cos(var0_37) * 3)
					end,
					rotationFun = function(arg0_38)
						return Vector3(0, arg0_38 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_39)
						local var0_39 = arg0_39 * 3 + 2.512

						return Vector3(math.sin(var0_39) * 3, 0.75, math.cos(var0_39) * 3)
					end,
					rotationFun = function(arg0_40)
						return Vector3(0, arg0_40 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_41)
						local var0_41 = arg0_41 * 3 - 2.512

						return Vector3(math.sin(var0_41) * 3, 0.75, math.cos(var0_41) * 3)
					end,
					rotationFun = function(arg0_42)
						return Vector3(0, arg0_42 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 65,
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
					centerPosFun = function(arg0_43)
						local var0_43 = arg0_43 * 3

						return Vector3(math.sin(var0_43) * 8, 0.75, math.cos(var0_43) * 8)
					end,
					rotationFun = function(arg0_44)
						return Vector3(0, arg0_44 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 65,
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
					centerPosFun = function(arg0_45)
						local var0_45 = arg0_45 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(var0_45) * 8, 0.75, math.cos(var0_45) * 8)
					end,
					rotationFun = function(arg0_46)
						return Vector3(0, arg0_46 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 65,
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
					centerPosFun = function(arg0_47)
						local var0_47 = arg0_47 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(var0_47) * 8, 0.75, math.cos(var0_47) * 8)
					end,
					rotationFun = function(arg0_48)
						return Vector3(0, arg0_48 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_49)
						local var0_49 = arg0_49 * 3

						return Vector3(math.sin(var0_49) * 3, 0.75, math.cos(var0_49) * 3)
					end,
					rotationFun = function(arg0_50)
						return Vector3(0, arg0_50 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_51)
						local var0_51 = arg0_51 * 3 + 2.512

						return Vector3(math.sin(var0_51) * 3, 0.75, math.cos(var0_51) * 3)
					end,
					rotationFun = function(arg0_52)
						return Vector3(0, arg0_52 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_53)
						local var0_53 = arg0_53 * 3 - 2.512

						return Vector3(math.sin(var0_53) * 3, 0.75, math.cos(var0_53) * 3)
					end,
					rotationFun = function(arg0_54)
						return Vector3(0, arg0_54 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 70,
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
					centerPosFun = function(arg0_55)
						local var0_55 = arg0_55 * 3

						return Vector3(math.sin(var0_55) * 8, 0.75, math.cos(var0_55) * 8)
					end,
					rotationFun = function(arg0_56)
						return Vector3(0, arg0_56 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 70,
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
					centerPosFun = function(arg0_57)
						local var0_57 = arg0_57 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(var0_57) * 8, 0.75, math.cos(var0_57) * 8)
					end,
					rotationFun = function(arg0_58)
						return Vector3(0, arg0_58 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 70,
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
					centerPosFun = function(arg0_59)
						local var0_59 = arg0_59 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(var0_59) * 8, 0.75, math.cos(var0_59) * 8)
					end,
					rotationFun = function(arg0_60)
						return Vector3(0, arg0_60 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_61)
						local var0_61 = arg0_61 * 3

						return Vector3(math.sin(var0_61) * 3, 0.75, math.cos(var0_61) * 3)
					end,
					rotationFun = function(arg0_62)
						return Vector3(0, arg0_62 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_63)
						local var0_63 = arg0_63 * 3 + 2.512

						return Vector3(math.sin(var0_63) * 3, 0.75, math.cos(var0_63) * 3)
					end,
					rotationFun = function(arg0_64)
						return Vector3(0, arg0_64 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_65)
						local var0_65 = arg0_65 * 3 - 2.512

						return Vector3(math.sin(var0_65) * 3, 0.75, math.cos(var0_65) * 3)
					end,
					rotationFun = function(arg0_66)
						return Vector3(0, arg0_66 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 75,
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
					centerPosFun = function(arg0_67)
						local var0_67 = arg0_67 * 3

						return Vector3(math.sin(var0_67) * 8, 0.75, math.cos(var0_67) * 8)
					end,
					rotationFun = function(arg0_68)
						return Vector3(0, arg0_68 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 75,
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
					centerPosFun = function(arg0_69)
						local var0_69 = arg0_69 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(var0_69) * 8, 0.75, math.cos(var0_69) * 8)
					end,
					rotationFun = function(arg0_70)
						return Vector3(0, arg0_70 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 75,
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
					centerPosFun = function(arg0_71)
						local var0_71 = arg0_71 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(var0_71) * 8, 0.75, math.cos(var0_71) * 8)
					end,
					rotationFun = function(arg0_72)
						return Vector3(0, arg0_72 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_73)
						local var0_73 = arg0_73 * 3

						return Vector3(math.sin(var0_73) * 3, 0.75, math.cos(var0_73) * 3)
					end,
					rotationFun = function(arg0_74)
						return Vector3(0, arg0_74 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_75)
						local var0_75 = arg0_75 * 3 + 2.512

						return Vector3(math.sin(var0_75) * 3, 0.75, math.cos(var0_75) * 3)
					end,
					rotationFun = function(arg0_76)
						return Vector3(0, arg0_76 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_77)
						local var0_77 = arg0_77 * 3 - 2.512

						return Vector3(math.sin(var0_77) * 3, 0.75, math.cos(var0_77) * 3)
					end,
					rotationFun = function(arg0_78)
						return Vector3(0, arg0_78 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 80,
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
					centerPosFun = function(arg0_79)
						local var0_79 = arg0_79 * 3

						return Vector3(math.sin(var0_79) * 8, 0.75, math.cos(var0_79) * 8)
					end,
					rotationFun = function(arg0_80)
						return Vector3(0, arg0_80 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 80,
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
					centerPosFun = function(arg0_81)
						local var0_81 = arg0_81 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(var0_81) * 8, 0.75, math.cos(var0_81) * 8)
					end,
					rotationFun = function(arg0_82)
						return Vector3(0, arg0_82 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 80,
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
					centerPosFun = function(arg0_83)
						local var0_83 = arg0_83 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(var0_83) * 8, 0.75, math.cos(var0_83) * 8)
					end,
					rotationFun = function(arg0_84)
						return Vector3(0, arg0_84 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_85)
						local var0_85 = arg0_85 * 3

						return Vector3(math.sin(var0_85) * 3, 0.75, math.cos(var0_85) * 3)
					end,
					rotationFun = function(arg0_86)
						return Vector3(0, arg0_86 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_87)
						local var0_87 = arg0_87 * 3 + 2.512

						return Vector3(math.sin(var0_87) * 3, 0.75, math.cos(var0_87) * 3)
					end,
					rotationFun = function(arg0_88)
						return Vector3(0, arg0_88 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_89)
						local var0_89 = arg0_89 * 3 - 2.512

						return Vector3(math.sin(var0_89) * 3, 0.75, math.cos(var0_89) * 3)
					end,
					rotationFun = function(arg0_90)
						return Vector3(0, arg0_90 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 85,
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
					centerPosFun = function(arg0_91)
						local var0_91 = arg0_91 * 3

						return Vector3(math.sin(var0_91) * 8, 0.75, math.cos(var0_91) * 8)
					end,
					rotationFun = function(arg0_92)
						return Vector3(0, arg0_92 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 85,
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
					centerPosFun = function(arg0_93)
						local var0_93 = arg0_93 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(var0_93) * 8, 0.75, math.cos(var0_93) * 8)
					end,
					rotationFun = function(arg0_94)
						return Vector3(0, arg0_94 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 85,
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
					centerPosFun = function(arg0_95)
						local var0_95 = arg0_95 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(var0_95) * 8, 0.75, math.cos(var0_95) * 8)
					end,
					rotationFun = function(arg0_96)
						return Vector3(0, arg0_96 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_97)
						local var0_97 = arg0_97 * 3

						return Vector3(math.sin(var0_97) * 3, 0.75, math.cos(var0_97) * 3)
					end,
					rotationFun = function(arg0_98)
						return Vector3(0, arg0_98 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_99)
						local var0_99 = arg0_99 * 3 + 2.512

						return Vector3(math.sin(var0_99) * 3, 0.75, math.cos(var0_99) * 3)
					end,
					rotationFun = function(arg0_100)
						return Vector3(0, arg0_100 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_101)
						local var0_101 = arg0_101 * 3 - 2.512

						return Vector3(math.sin(var0_101) * 3, 0.75, math.cos(var0_101) * 3)
					end,
					rotationFun = function(arg0_102)
						return Vector3(0, arg0_102 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 90,
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
					centerPosFun = function(arg0_103)
						local var0_103 = arg0_103 * 3

						return Vector3(math.sin(var0_103) * 8, 0.75, math.cos(var0_103) * 8)
					end,
					rotationFun = function(arg0_104)
						return Vector3(0, arg0_104 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 90,
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
					centerPosFun = function(arg0_105)
						local var0_105 = arg0_105 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(var0_105) * 8, 0.75, math.cos(var0_105) * 8)
					end,
					rotationFun = function(arg0_106)
						return Vector3(0, arg0_106 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 90,
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
					centerPosFun = function(arg0_107)
						local var0_107 = arg0_107 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(var0_107) * 8, 0.75, math.cos(var0_107) * 8)
					end,
					rotationFun = function(arg0_108)
						return Vector3(0, arg0_108 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_109)
						local var0_109 = arg0_109 * 3

						return Vector3(math.sin(var0_109) * 3, 0.75, math.cos(var0_109) * 3)
					end,
					rotationFun = function(arg0_110)
						return Vector3(0, arg0_110 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_111)
						local var0_111 = arg0_111 * 3 + 2.512

						return Vector3(math.sin(var0_111) * 3, 0.75, math.cos(var0_111) * 3)
					end,
					rotationFun = function(arg0_112)
						return Vector3(0, arg0_112 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_113)
						local var0_113 = arg0_113 * 3 - 2.512

						return Vector3(math.sin(var0_113) * 3, 0.75, math.cos(var0_113) * 3)
					end,
					rotationFun = function(arg0_114)
						return Vector3(0, arg0_114 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 95,
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
					centerPosFun = function(arg0_115)
						local var0_115 = arg0_115 * 3

						return Vector3(math.sin(var0_115) * 8, 0.75, math.cos(var0_115) * 8)
					end,
					rotationFun = function(arg0_116)
						return Vector3(0, arg0_116 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 95,
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
					centerPosFun = function(arg0_117)
						local var0_117 = arg0_117 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(var0_117) * 8, 0.75, math.cos(var0_117) * 8)
					end,
					rotationFun = function(arg0_118)
						return Vector3(0, arg0_118 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
					effect = "shield06",
					damage = 95,
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
					centerPosFun = function(arg0_119)
						local var0_119 = arg0_119 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(var0_119) * 8, 0.75, math.cos(var0_119) * 8)
					end,
					rotationFun = function(arg0_120)
						return Vector3(0, arg0_120 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_121)
						local var0_121 = arg0_121 * 3

						return Vector3(math.sin(var0_121) * 3, 0.75, math.cos(var0_121) * 3)
					end,
					rotationFun = function(arg0_122)
						return Vector3(0, arg0_122 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_123)
						local var0_123 = arg0_123 * 3 + 2.512

						return Vector3(math.sin(var0_123) * 3, 0.75, math.cos(var0_123) * 3)
					end,
					rotationFun = function(arg0_124)
						return Vector3(0, arg0_124 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 234, 0)
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
					effect = "shield05",
					count = 2,
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
					centerPosFun = function(arg0_125)
						local var0_125 = arg0_125 * 3 - 2.512

						return Vector3(math.sin(var0_125) * 3, 0.75, math.cos(var0_125) * 3)
					end,
					rotationFun = function(arg0_126)
						return Vector3(0, arg0_126 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 54, 0)
					end
				}
			},
			{
				id = 4,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
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
					centerPosFun = function(arg0_127)
						local var0_127 = arg0_127 * 3

						return Vector3(math.sin(var0_127) * 8, 0.75, math.cos(var0_127) * 8)
					end,
					rotationFun = function(arg0_128)
						return Vector3(0, arg0_128 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 90, 0)
					end
				}
			},
			{
				id = 5,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
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
					centerPosFun = function(arg0_129)
						local var0_129 = arg0_129 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_2

						return Vector3(math.sin(var0_129) * 8, 0.75, math.cos(var0_129) * 8)
					end,
					rotationFun = function(arg0_130)
						return Vector3(0, arg0_130 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST + 210, 0)
					end
				}
			},
			{
				id = 6,
				type = "BattleBuffDamageWall",
				trigger = {
					"onStack",
					"onUpdate"
				},
				arg_list = {
					count = 6,
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
					centerPosFun = function(arg0_131)
						local var0_131 = arg0_131 * 3 + ys.Battle.BattleConfig.SHIELD_CENTER_CONST_4

						return Vector3(math.sin(var0_131) * 8, 0.75, math.cos(var0_131) * 8)
					end,
					rotationFun = function(arg0_132)
						return Vector3(0, arg0_132 * ys.Battle.BattleConfig.SHIELD_ROTATE_CONST - 20, 0)
					end
				}
			}
		}
	},
	init_effect = "",
	name = "",
	time = 10,
	picture = "",
	desc = "守卫之盾",
	stack = 1,
	id = 152361,
	icon = 152361,
	last_effect = ""
}
