return {
	map_id = 10001,
	id = 1926003,
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
						id = "GAOTASHANGDEQIANGWEI26-1"
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
							monsterTemplateID = 16736022,
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
							monsterTemplateID = 16736023,
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
							monsterTemplateID = 16736022,
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
							monsterTemplateID = 16736023,
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
							monsterTemplateID = 16736023,
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
							monsterTemplateID = 16736022,
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
							monsterTemplateID = 16736021,
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
							monsterTemplateID = 16736021,
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
							monsterTemplateID = 16736022,
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
							monsterTemplateID = 16736024,
							reinforceDelay = 6,
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
							buffList = {},
							phase = {
								{
									switchParam = 2,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 20006
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 1.5,
									addWeapon = {
										3272201,
										3272202
									}
								},
								{
									index = 2,
									switchType = 1,
									switchTo = 3,
									switchParam = 8,
									addWeapon = {
										3272203,
										3272204
									}
								},
								{
									index = 3,
									switchParam = 12,
									switchTo = 4,
									switchType = 1,
									addWeapon = {
										3272205,
										3272206
									},
									removeWeapon = {
										3272203,
										3272204
									}
								},
								{
									index = 4,
									switchParam = 2,
									switchTo = 5,
									switchType = 1,
									addWeapon = {
										3272207
									},
									removeWeapon = {
										3272205,
										3272206
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 8,
									addWeapon = {
										3272208
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 2,
									switchParam = 3,
									removeWeapon = {
										3272207,
										3272208
									}
								}
							}
						}
					},
					reinforcement = {
						{
							monsterTemplateID = 16736022,
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
							monsterTemplateID = 16736022,
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
					triggerType = 3,
					waveIndex = 502,
					preWaves = {
						102
					},
					triggerParams = {
						id = "GAOTASHANGDEQIANGWEI26-2"
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
						id = "GAOTASHANGDEQIANGWEI26-3"
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
						id = 201413,
						level = 1
					}
				}
			}
		},
		main_unitList = {
			{
				tmpID = 900504,
				configId = 900504,
				skinId = 9704040,
				id = 1,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 800,
					air = 0,
					antiaircraft = 250,
					torpedo = 0,
					durability = 100000,
					reload = 600,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 800540,
						level = 10
					},
					{
						id = 800550,
						level = 10
					},
					{
						id = 800560,
						level = 10
					},
					{
						id = 800572,
						level = 10
					},
					{
						id = 2,
						level = 10
					},
					{
						id = 340,
						level = 10
					}
				}
			},
			{
				tmpID = 900505,
				configId = 900505,
				skinId = 9704030,
				id = 2,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 800,
					air = 0,
					antiaircraft = 250,
					torpedo = 0,
					durability = 100000,
					reload = 600,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 150
				},
				skills = {
					{
						id = 800460,
						level = 10
					},
					{
						id = 800470,
						level = 10
					},
					{
						id = 800480,
						level = 10
					},
					{
						id = 800492,
						level = 10
					},
					{
						id = 2,
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
