return {
	map_id = 10001,
	id = 1926002,
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
						timeout = 1
					}
				},
				{
					triggerType = 3,
					waveIndex = 501,
					preWaves = {
						100
					},
					triggerParams = {
						id = "GAOTASHANGDEQIANGWEI18-1"
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
							monsterTemplateID = 16736003,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								0,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16736004,
							delay = 0,
							sickness = 0.1,
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
							monsterTemplateID = 16736003,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								0,
								0,
								35
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
					waveIndex = 102,
					conditionType = 1,
					preWaves = {
						101
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16736005,
							reinforceDelay = 6,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								0,
								0,
								60
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16736005,
							reinforceDelay = 6,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								0,
								0,
								40
							},
							buffList = {
								8001,
								8007
							}
						}
					},
					reinforcement = {
						{
							monsterTemplateID = 16736003,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								-5,
								0,
								75
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16736002,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								-10,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16736002,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								-10,
								0,
								35
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16736003,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								-5,
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
							monsterTemplateID = 16736007,
							reinforceDelay = 6,
							delay = 0.1,
							corrdinate = {
								-10,
								0,
								50
							},
							bossData = {
								hpBarNum = 60,
								icon = ""
							},
							buffList = {},
							phase = {
								{
									switchType = 1,
									switchTo = 1,
									index = 0,
									switchParam = 2,
									setAI = 20006,
									addWeapon = {
										3273001
									}
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 7,
									addWeapon = {
										3273004,
										3273005
									}
								},
								{
									index = 2,
									switchType = 1,
									switchTo = 3,
									switchParam = 2,
									removeWeapon = {
										3273004,
										3273005
									}
								},
								{
									index = 3,
									switchType = 1,
									switchTo = 4,
									switchParam = 11,
									addWeapon = {
										3273006,
										3273007,
										3273008
									}
								},
								{
									index = 4,
									switchType = 1,
									switchTo = 5,
									switchParam = 1.5,
									removeWeapon = {
										3273006,
										3273007,
										3273008
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 2,
									addWeapon = {
										3273009
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 7,
									switchParam = 3,
									addWeapon = {
										3273010
									}
								},
								{
									index = 7,
									switchType = 1,
									switchTo = 8,
									switchParam = 2,
									addWeapon = {
										3273011
									}
								},
								{
									index = 8,
									switchType = 1,
									switchTo = 9,
									switchParam = 1,
									removeWeapon = {
										3273010
									}
								},
								{
									index = 9,
									switchType = 1,
									switchTo = 10,
									switchParam = 2,
									addWeapon = {
										3273010
									}
								},
								{
									index = 10,
									switchType = 1,
									switchTo = 11,
									switchParam = 1,
									removeWeapon = {
										3273011
									}
								},
								{
									index = 11,
									switchType = 1,
									switchTo = 12,
									switchParam = 5.5,
									addWeapon = {
										3273011
									}
								},
								{
									index = 12,
									switchType = 1,
									switchTo = 1,
									switchParam = 2,
									removeWeapon = {
										3273009,
										3273010,
										3273011
									}
								}
							}
						}
					},
					reinforcement = {
						{
							monsterTemplateID = 16736002,
							delay = 0,
							sickness = 0.1,
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
							monsterTemplateID = 16736002,
							delay = 0,
							sickness = 0.1,
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
					triggerType = 1,
					waveIndex = 201,
					preWaves = {
						501
					},
					triggerParams = {
						timeout = 24
					}
				},
				{
					triggerType = 3,
					waveIndex = 502,
					preWaves = {
						201
					},
					triggerParams = {
						id = "GAOTASHANGDEQIANGWEI18-2"
					}
				},
				{
					triggerType = 8,
					waveIndex = 900,
					preWaves = {
						103
					},
					triggerParams = {}
				},
				{
					triggerType = 3,
					key = true,
					waveIndex = 503,
					preWaves = {
						900
					},
					triggerParams = {
						id = "GAOTASHANGDEQIANGWEI18-3"
					}
				}
			}
		}
	},
	fleet_prefab = {
		vanguard_unitList = {
			{
				tmpID = 900506,
				configId = 900506,
				skinId = 900506,
				id = 1,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 600,
					air = 600,
					antiaircraft = 250,
					torpedo = 600,
					durability = 200000,
					reload = 600,
					armor = 0,
					dodge = 50,
					speed = 35,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 340,
						level = 10
					},
					{
						id = 201412,
						level = 2
					},
					{
						id = 201413,
						level = 1
					}
				}
			}
		}
	}
}
