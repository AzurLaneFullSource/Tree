return {
	effect_list = {
		{
			id = 1,
			type = "BattleBuffShieldWall",
			trigger = {
				"onUpdate"
			},
			arg_list = {
				do_when_hit = "intercept",
				effect = "leigensitebao_longdun",
				count = 2,
				bulletType = 1,
				cld_list = {
					{
						box = {
							4,
							6,
							9
						},
						offset = {
							2,
							0,
							0
						}
					}
				},
				centerPosFun = function(arg0_1)
					return Vector3(3, 1.5, 0.5)
				end,
				rotationFun = function(arg0_2)
					return Vector3(0, 192, 0)
				end
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onShieldBroken"
			},
			arg_list = {
				target = "TargetSelf",
				shieldBuffID = 16723,
				skill_id = 16721
			}
		},
		{
			type = "BattleBuffCastSkill",
			trigger = {
				"onRemove"
			},
			arg_list = {
				skill_id = 16721,
				target = "TargetSelf"
			}
		}
	},
	{
		effect_list = {
			{
				id = 1,
				type = "BattleBuffShieldWall",
				trigger = {
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "leigensitebao_longdun",
					count = 2,
					bulletType = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								2,
								0,
								0
							}
						}
					},
					centerPosFun = function(arg0_3)
						return Vector3(3, 1.5, 0.5)
					end,
					rotationFun = function(arg0_4)
						return Vector3(0, 192, 0)
					end
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onShieldBroken"
				},
				arg_list = {
					target = "TargetSelf",
					shieldBuffID = 16723,
					skill_id = 16721
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onRemove"
				},
				arg_list = {
					skill_id = 16721,
					target = "TargetSelf"
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
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "leigensitebao_longdun",
					count = 2,
					bulletType = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								2,
								0,
								0
							}
						}
					},
					centerPosFun = function(arg0_5)
						return Vector3(3, 1.5, 0.5)
					end,
					rotationFun = function(arg0_6)
						return Vector3(0, 192, 0)
					end
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onShieldBroken"
				},
				arg_list = {
					target = "TargetSelf",
					shieldBuffID = 16723,
					skill_id = 16721
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onRemove"
				},
				arg_list = {
					skill_id = 16721,
					target = "TargetSelf"
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
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "leigensitebao_longdun",
					count = 3,
					bulletType = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								2,
								0,
								0
							}
						}
					},
					centerPosFun = function(arg0_7)
						return Vector3(3, 1.5, 0.5)
					end,
					rotationFun = function(arg0_8)
						return Vector3(0, 192, 0)
					end
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onShieldBroken"
				},
				arg_list = {
					target = "TargetSelf",
					shieldBuffID = 16723,
					skill_id = 16721
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onRemove"
				},
				arg_list = {
					skill_id = 16721,
					target = "TargetSelf"
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
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "leigensitebao_longdun",
					count = 3,
					bulletType = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								2,
								0,
								0
							}
						}
					},
					centerPosFun = function(arg0_9)
						return Vector3(3, 1.5, 0.5)
					end,
					rotationFun = function(arg0_10)
						return Vector3(0, 192, 0)
					end
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onShieldBroken"
				},
				arg_list = {
					target = "TargetSelf",
					shieldBuffID = 16723,
					skill_id = 16721
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onRemove"
				},
				arg_list = {
					skill_id = 16721,
					target = "TargetSelf"
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
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "leigensitebao_longdun",
					count = 4,
					bulletType = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								2,
								0,
								0
							}
						}
					},
					centerPosFun = function(arg0_11)
						return Vector3(3, 1.5, 0.5)
					end,
					rotationFun = function(arg0_12)
						return Vector3(0, 192, 0)
					end
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onShieldBroken"
				},
				arg_list = {
					target = "TargetSelf",
					shieldBuffID = 16723,
					skill_id = 16721
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onRemove"
				},
				arg_list = {
					skill_id = 16721,
					target = "TargetSelf"
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
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "leigensitebao_longdun",
					count = 4,
					bulletType = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								2,
								0,
								0
							}
						}
					},
					centerPosFun = function(arg0_13)
						return Vector3(3, 1.5, 0.5)
					end,
					rotationFun = function(arg0_14)
						return Vector3(0, 192, 0)
					end
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onShieldBroken"
				},
				arg_list = {
					target = "TargetSelf",
					shieldBuffID = 16723,
					skill_id = 16721
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onRemove"
				},
				arg_list = {
					skill_id = 16721,
					target = "TargetSelf"
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
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "leigensitebao_longdun",
					count = 5,
					bulletType = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								2,
								0,
								0
							}
						}
					},
					centerPosFun = function(arg0_15)
						return Vector3(3, 1.5, 0.5)
					end,
					rotationFun = function(arg0_16)
						return Vector3(0, 192, 0)
					end
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onShieldBroken"
				},
				arg_list = {
					target = "TargetSelf",
					shieldBuffID = 16723,
					skill_id = 16721
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onRemove"
				},
				arg_list = {
					skill_id = 16721,
					target = "TargetSelf"
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
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "leigensitebao_longdun",
					count = 5,
					bulletType = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								2,
								0,
								0
							}
						}
					},
					centerPosFun = function(arg0_17)
						return Vector3(3, 1.5, 0.5)
					end,
					rotationFun = function(arg0_18)
						return Vector3(0, 192, 0)
					end
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onShieldBroken"
				},
				arg_list = {
					target = "TargetSelf",
					shieldBuffID = 16723,
					skill_id = 16721
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onRemove"
				},
				arg_list = {
					skill_id = 16721,
					target = "TargetSelf"
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
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "leigensitebao_longdun",
					count = 6,
					bulletType = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								2,
								0,
								0
							}
						}
					},
					centerPosFun = function(arg0_19)
						return Vector3(3, 1.5, 0.5)
					end,
					rotationFun = function(arg0_20)
						return Vector3(0, 192, 0)
					end
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onShieldBroken"
				},
				arg_list = {
					target = "TargetSelf",
					shieldBuffID = 16723,
					skill_id = 16721
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onRemove"
				},
				arg_list = {
					skill_id = 16721,
					target = "TargetSelf"
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
					"onUpdate"
				},
				arg_list = {
					do_when_hit = "intercept",
					effect = "leigensitebao_longdun",
					count = 6,
					bulletType = 1,
					cld_list = {
						{
							box = {
								4,
								6,
								9
							},
							offset = {
								2,
								0,
								0
							}
						}
					},
					centerPosFun = function(arg0_21)
						return Vector3(3, 1.5, 0.5)
					end,
					rotationFun = function(arg0_22)
						return Vector3(0, 192, 0)
					end
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onShieldBroken"
				},
				arg_list = {
					target = "TargetSelf",
					shieldBuffID = 16723,
					skill_id = 16721
				}
			},
			{
				type = "BattleBuffCastSkill",
				trigger = {
					"onRemove"
				},
				arg_list = {
					skill_id = 16721,
					target = "TargetSelf"
				}
			}
		}
	},
	init_effect = "",
	name = "",
	time = 8,
	color = "blue",
	picture = "",
	desc = "",
	stack = 1,
	id = 16723,
	icon = 16723,
	last_effect = ""
}
