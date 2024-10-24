return {
	map_id = 10001,
	id = 1868003,
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
						id = "JUFENGYUCHENMIANZHIHAI11-1"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 101,
					conditionType = 1,
					preWaves = {
						100
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16678201,
							delay = 0,
							corrdinate = {
								-10,
								0,
								72
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16678203,
							delay = 0,
							corrdinate = {
								-5,
								0,
								52
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16678201,
							delay = 0,
							corrdinate = {
								-10,
								0,
								32
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 102,
					conditionType = 1,
					preWaves = {
						101
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16678204,
							delay = 0,
							corrdinate = {
								-5,
								0,
								52
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16678202,
							delay = 0,
							corrdinate = {
								-12,
								0,
								62
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16678202,
							delay = 0,
							corrdinate = {
								-12,
								0,
								42
							},
							buffList = {
								8001,
								8007
							}
						}
					},
					reinforcement = {
						{
							monsterTemplateID = 16678201,
							delay = 0,
							corrdinate = {
								-5,
								0,
								74
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16678201,
							delay = 0,
							corrdinate = {
								-5,
								0,
								30
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 103,
					conditionType = 0,
					preWaves = {
						102
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16678204,
							reinforceDelay = 6,
							delay = 0,
							corrdinate = {
								-5,
								0,
								52
							},
							buffList = {
								8001,
								8007
							}
						}
					},
					reinforcement = {
						{
							monsterTemplateID = 16678203,
							delay = 0,
							corrdinate = {
								0,
								0,
								74
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16678203,
							delay = 0,
							corrdinate = {
								0,
								0,
								30
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16678202,
							delay = 0,
							corrdinate = {
								5,
								0,
								62
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16678202,
							delay = 0,
							corrdinate = {
								5,
								0,
								42
							},
							buffList = {
								8001,
								8007
							}
						}
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 104,
					conditionType = 1,
					preWaves = {
						103
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16678205,
							delay = 0.1,
							corrdinate = {
								-10,
								0,
								50
							},
							bossData = {
								hpBarNum = 80,
								icon = ""
							},
							buffList = {
								200914
							},
							phase = {
								{
									switchParam = 1.5,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 20006
								},
								{
									switchType = 1,
									switchTo = 3,
									index = 1,
									switchParam = 8,
									setAI = 10001,
									addWeapon = {
										3214003,
										3214004,
										3214005
									}
								},
								{
									switchParam = 2,
									switchTo = 4,
									index = 3,
									switchType = 1,
									setAI = 75016
								},
								{
									index = 4,
									switchParam = 12,
									switchTo = 5,
									switchType = 1,
									addWeapon = {
										3214006,
										3214007
									},
									removeWeapon = {
										3214003,
										3214004,
										3214005
									}
								},
								{
									index = 5,
									switchParam = 11,
									switchTo = 6,
									switchType = 1,
									addWeapon = {
										3214008,
										3214009
									},
									removeWeapon = {
										3214006,
										3214007
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 1,
									switchParam = 3.5,
									removeWeapon = {
										3214008,
										3214009
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
						104
					},
					triggerParams = {}
				},
				{
					triggerType = 3,
					key = true,
					waveIndex = 502,
					preWaves = {
						900
					},
					triggerParams = {
						id = "JUFENGYUCHENMIANZHIHAI11-2"
					}
				}
			}
		}
	},
	fleet_prefab = {
		vanguard_unitList = {
			{
				tmpID = 900466,
				configId = 900466,
				skinId = 9600100,
				id = 1,
				level = 100,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 150,
					air = 0,
					antiaircraft = 200,
					torpedo = 100,
					durability = 50000,
					reload = 300,
					armor = 0,
					dodge = 30,
					speed = 30,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 150630,
						level = 10
					},
					{
						id = 150640,
						level = 10
					},
					{
						id = 30382,
						level = 10
					}
				}
			},
			{
				tmpID = 900461,
				configId = 900461,
				skinId = 9600010,
				id = 2,
				level = 100,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 150,
					air = 0,
					antiaircraft = 200,
					torpedo = 100,
					durability = 50000,
					reload = 300,
					armor = 0,
					dodge = 30,
					speed = 30,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 16180,
						level = 10
					},
					{
						id = 16190,
						level = 10
					},
					{
						id = 29962,
						level = 10
					}
				}
			},
			{
				tmpID = 900462,
				configId = 900462,
				skinId = 9600040,
				id = 3,
				level = 100,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 150,
					air = 0,
					antiaircraft = 200,
					torpedo = 100,
					durability = 50000,
					reload = 300,
					armor = 0,
					dodge = 30,
					speed = 30,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 17160,
						level = 10
					},
					{
						id = 30132,
						level = 10
					}
				}
			}
		},
		main_unitList = {
			{
				tmpID = 900463,
				configId = 900463,
				skinId = 9600020,
				id = 1,
				level = 100,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 300,
					air = 0,
					antiaircraft = 250,
					torpedo = 0,
					durability = 50000,
					reload = 600,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 17190,
						level = 10
					},
					{
						id = 17200,
						level = 10
					},
					{
						id = 152,
						level = 10
					},
					{
						id = 340,
						level = 10
					},
					{
						id = 201159,
						level = 2
					}
				}
			},
			{
				tmpID = 900464,
				configId = 900464,
				skinId = 9600030,
				id = 2,
				level = 100,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 300,
					air = 0,
					antiaircraft = 250,
					torpedo = 0,
					durability = 50000,
					reload = 600,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 17240,
						level = 10
					},
					{
						id = 17250,
						level = 10
					},
					{
						id = 30152,
						level = 10
					},
					{
						id = 151,
						level = 10
					},
					{
						id = 340,
						level = 10
					}
				}
			},
			{
				tmpID = 900465,
				configId = 900465,
				skinId = 9600060,
				id = 3,
				level = 100,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 300,
					air = 0,
					antiaircraft = 250,
					torpedo = 0,
					durability = 50000,
					reload = 600,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 17260,
						level = 10
					},
					{
						id = 17270,
						level = 10
					},
					{
						id = 30162,
						level = 10
					},
					{
						id = 151,
						level = 10
					},
					{
						id = 340,
						level = 10
					}
				}
			}
		}
	}
}
