return {
	map_id = 10001,
	id = 1826001,
	stages = {
		{
			stageIndex = 1,
			failCondition = 1,
			timeCount = 300,
			passCondition = 1,
			backGroundStageID = 1,
			totalArea = {
				-80,
				20,
				90,
				70
			},
			playerArea = {
				-80,
				20,
				45,
				68
			},
			enemyArea = {},
			fleetCorrdinate = {
				-80,
				0,
				75
			},
			waves = {
				{
					triggerType = 1,
					waveIndex = 100,
					preWaves = {},
					triggerParams = {
						timeout = 0.5
					}
				},
				{
					triggerType = 3,
					waveIndex = 501,
					preWaves = {
						100
					},
					triggerParams = {
						id = "HUANMENGJIANZOUQU4-1"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 101,
					conditionType = 1,
					preWaves = {
						501
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16636002,
							delay = 0,
							corrdinate = {
								5,
								0,
								75
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16636001,
							delay = 0,
							corrdinate = {
								0,
								0,
								62
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16636003,
							delay = 0,
							corrdinate = {
								-5,
								0,
								50
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16636001,
							delay = 0,
							corrdinate = {
								0,
								0,
								38
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16636002,
							delay = 0,
							corrdinate = {
								5,
								0,
								25
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 3,
					waveIndex = 502,
					preWaves = {
						101
					},
					triggerParams = {
						id = "HUANMENGJIANZOUQU4-2"
					}
				},
				{
					triggerType = 5,
					waveIndex = 400,
					preWaves = {
						502
					},
					triggerParams = {
						bgm = "battle-maid"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 102,
					conditionType = 0,
					preWaves = {
						502
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16636101,
							delay = 0,
							corrdinate = {
								-10,
								0,
								70
							},
							buffList = {},
							phase = {
								{
									switchParam = 1.5,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 70149
								}
							}
						},
						{
							monsterTemplateID = 16636102,
							delay = 0,
							corrdinate = {
								-10,
								0,
								30
							},
							buffList = {},
							hase = {
								{
									switchParam = 1.5,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 70150
								}
							}
						},
						{
							monsterTemplateID = 16636201,
							delay = 0.1,
							corrdinate = {
								-5,
								0,
								50
							},
							bossData = {
								hpBarNum = 10,
								icon = ""
							},
							buffList = {},
							phase = {
								{
									switchParam = 1.5,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 10001
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 4,
									addWeapon = {
										3170001,
										3170002
									}
								},
								{
									index = 2,
									switchParam = 4,
									switchTo = 3,
									switchType = 1,
									addWeapon = {
										3170003,
										3170004
									},
									removeWeapon = {
										3170001,
										3170002
									}
								},
								{
									index = 3,
									switchParam = 8,
									switchTo = 4,
									switchType = 1,
									addWeapon = {
										3170005
									},
									removeWeapon = {
										3170003,
										3170004
									}
								},
								{
									index = 4,
									switchParam = 2,
									switchTo = 1,
									switchType = 1,
									addWeapon = {},
									removeWeapon = {
										3170005
									}
								}
							}
						}
					}
				},
				{
					triggerType = 3,
					waveIndex = 503,
					preWaves = {
						102
					},
					triggerParams = {
						id = "HUANMENGJIANZOUQU4-3"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 103,
					conditionType = 1,
					preWaves = {
						503
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16636005,
							delay = 0,
							corrdinate = {
								5,
								0,
								75
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16636004,
							delay = 0,
							corrdinate = {
								0,
								0,
								62
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16636006,
							delay = 0,
							corrdinate = {
								-5,
								0,
								50
							},
							buffList = {
								8001,
								8007,
								200972
							}
						},
						{
							monsterTemplateID = 16636004,
							delay = 0,
							corrdinate = {
								0,
								0,
								38
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16636005,
							delay = 0,
							corrdinate = {
								5,
								0,
								25
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 3,
					waveIndex = 504,
					preWaves = {
						103
					},
					triggerParams = {
						id = "HUANMENGJIANZOUQU4-4"
					}
				},
				{
					triggerType = 5,
					waveIndex = 401,
					preWaves = {
						504
					},
					triggerParams = {
						bgm = "battle-ironblood-brisk"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 104,
					conditionType = 0,
					preWaves = {
						504
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16636103,
							delay = 0,
							corrdinate = {
								-10,
								0,
								70
							},
							buffList = {},
							phase = {
								{
									switchParam = 1.5,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 70149
								}
							}
						},
						{
							monsterTemplateID = 16636104,
							delay = 0,
							corrdinate = {
								-10,
								0,
								30
							},
							buffList = {},
							hase = {
								{
									switchParam = 1.5,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 70150
								}
							}
						},
						{
							monsterTemplateID = 16636202,
							delay = 0.1,
							corrdinate = {
								-5,
								0,
								50
							},
							bossData = {
								hpBarNum = 10,
								icon = ""
							},
							buffList = {},
							phase = {
								{
									switchParam = 1.5,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 10001
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 5,
									addWeapon = {
										3171001,
										3171002
									}
								},
								{
									index = 2,
									switchParam = 4,
									switchTo = 3,
									switchType = 1,
									addWeapon = {
										3171003,
										3171004
									},
									removeWeapon = {
										3171001,
										3171002
									}
								},
								{
									index = 3,
									switchParam = 12,
									switchTo = 4,
									switchType = 1,
									addWeapon = {
										3171005,
										3171006
									},
									removeWeapon = {
										3171003,
										3171004
									}
								},
								{
									index = 4,
									switchParam = 3,
									switchTo = 1,
									switchType = 1,
									addWeapon = {},
									removeWeapon = {
										3171005,
										3171006
									}
								}
							}
						}
					}
				},
				{
					triggerType = 3,
					waveIndex = 505,
					preWaves = {
						104
					},
					triggerParams = {
						id = "HUANMENGJIANZOUQU4-5"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 105,
					conditionType = 1,
					preWaves = {
						505
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16636008,
							delay = 0,
							corrdinate = {
								5,
								0,
								75
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16636007,
							delay = 0,
							corrdinate = {
								0,
								0,
								62
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16636009,
							delay = 0,
							corrdinate = {
								-5,
								0,
								50
							},
							buffList = {
								8001,
								8007,
								200972
							}
						},
						{
							monsterTemplateID = 16636007,
							delay = 0,
							corrdinate = {
								0,
								0,
								38
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16636008,
							delay = 0,
							corrdinate = {
								5,
								0,
								25
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 3,
					waveIndex = 506,
					preWaves = {
						105
					},
					triggerParams = {
						id = "HUANMENGJIANZOUQU4-6"
					}
				},
				{
					triggerType = 5,
					waveIndex = 402,
					preWaves = {
						506
					},
					triggerParams = {
						bgm = "battle-roma-sky"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 106,
					conditionType = 0,
					preWaves = {
						506
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16636105,
							delay = 0,
							corrdinate = {
								-10,
								0,
								70
							},
							buffList = {},
							phase = {
								{
									switchParam = 1.5,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 70149
								}
							}
						},
						{
							monsterTemplateID = 16636106,
							delay = 0,
							corrdinate = {
								-10,
								0,
								30
							},
							buffList = {},
							hase = {
								{
									switchParam = 1.5,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 70150
								}
							}
						},
						{
							monsterTemplateID = 16636203,
							delay = 0.1,
							corrdinate = {
								-5,
								0,
								50
							},
							bossData = {
								hpBarNum = 10,
								icon = ""
							},
							buffList = {},
							phase = {
								{
									switchParam = 1.5,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 10001
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 5,
									addWeapon = {
										3172001,
										3172002
									}
								},
								{
									index = 2,
									switchParam = 9,
									switchTo = 3,
									switchType = 1,
									addWeapon = {
										3172003,
										3172004
									},
									removeWeapon = {
										3172001,
										3172002
									}
								},
								{
									index = 3,
									switchParam = 1,
									switchTo = 4,
									switchType = 1,
									addWeapon = {
										3172005
									},
									removeWeapon = {
										3172003,
										3172004
									}
								},
								{
									index = 4,
									switchParam = 11.5,
									switchTo = 5,
									switchType = 1,
									addWeapon = {
										3172006,
										3172007
									},
									removeWeapon = {}
								},
								{
									index = 5,
									switchParam = 1.5,
									switchTo = 1,
									switchType = 1,
									addWeapon = {},
									removeWeapon = {
										3172005,
										3172006,
										3172007
									}
								}
							}
						}
					}
				},
				{
					triggerType = 8,
					waveIndex = 900,
					preWaves = {
						106
					},
					triggerParams = {}
				},
				{
					triggerType = 3,
					key = true,
					waveIndex = 507,
					preWaves = {
						900
					},
					triggerParams = {
						id = "HUANMENGJIANZOUQU4-7"
					}
				}
			}
		}
	},
	fleet_prefab = {
		vanguard_unitList = {
			{
				tmpID = 900445,
				configId = 900445,
				skinId = 903030,
				id = 1,
				level = 110,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 320,
					air = 0,
					antiaircraft = 200,
					torpedo = 200,
					durability = 16000,
					reload = 400,
					armor = 0,
					dodge = 30,
					speed = 25,
					luck = 99,
					hit = 100
				},
				skills = {
					{
						id = 150210,
						level = 10
					},
					{
						id = 150220,
						level = 10
					},
					{
						id = 28222,
						level = 10
					}
				}
			},
			{
				tmpID = 900444,
				configId = 900444,
				skinId = 901140,
				id = 2,
				level = 110,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 200,
					air = 0,
					antiaircraft = 400,
					torpedo = 350,
					durability = 12000,
					reload = 400,
					armor = 0,
					dodge = 80,
					speed = 32,
					luck = 99,
					hit = 100
				},
				skills = {
					{
						id = 150230,
						level = 10
					},
					{
						id = 150240,
						level = 10
					},
					{
						id = 30322,
						level = 10
					}
				}
			}
		},
		main_unitList = {
			{
				tmpID = 900446,
				configId = 900446,
				skinId = 904020,
				id = 1,
				level = 110,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 400,
					air = 0,
					antiaircraft = 250,
					torpedo = 0,
					durability = 20000,
					reload = 800,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 150250,
						level = 10
					},
					{
						id = 150260,
						level = 10
					},
					{
						id = 1,
						level = 1
					}
				}
			}
		}
	}
}