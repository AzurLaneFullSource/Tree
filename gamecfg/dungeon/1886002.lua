return {
	map_id = 10001,
	id = 1886002,
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
						id = "XINGGUANGXIADEYUHUI12-1"
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
							monsterTemplateID = 16696001,
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
							monsterTemplateID = 16696002,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								-5,
								0,
								55
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16696001,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								5,
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
					key = true,
					waveIndex = 102,
					conditionType = 1,
					preWaves = {
						101
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16696003,
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
							monsterTemplateID = 16696001,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								5,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16696001,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								5,
								0,
								45
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16696003,
							delay = 0,
							sickness = 0.1,
							corrdinate = {
								-5,
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
					triggerType = 3,
					waveIndex = 502,
					preWaves = {
						102
					},
					triggerParams = {
						id = "XINGGUANGXIADEYUHUI12-2"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 103,
					conditionType = 1,
					preWaves = {
						502
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16696007,
							delay = 0.1,
							sickness = 0.1,
							corrdinate = {
								-5,
								0,
								50
							},
							bossData = {
								hpBarNum = 60,
								icon = ""
							}
						},
						{
							monsterTemplateID = 16696001,
							delay = 0,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								5,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16696001,
							delay = 0,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								5,
								0,
								45
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16696003,
							delay = 5,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								10,
								0,
								75
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16696003,
							delay = 5,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								10,
								0,
								25
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16696001,
							delay = 7,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								5,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16696001,
							delay = 7,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								5,
								0,
								45
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16696004,
							delay = 10,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								-20,
								0,
								75
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16696004,
							delay = 10,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								-20,
								0,
								25
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16696002,
							delay = 12,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								0,
								0,
								75
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16696002,
							delay = 12,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								0,
								0,
								25
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16696002,
							delay = 15,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								-20,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16696002,
							delay = 15,
							score = 0,
							sickness = 0.1,
							corrdinate = {
								-20,
								0,
								45
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16696003,
							delay = 17,
							score = 0,
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
							monsterTemplateID = 16696003,
							delay = 17,
							score = 0,
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
					triggerType = 1,
					waveIndex = 104,
					preWaves = {
						502
					},
					triggerParams = {
						timeout = 21
					}
				},
				{
					triggerType = 3,
					key = true,
					waveIndex = 503,
					preWaves = {
						104
					},
					triggerParams = {
						id = "XINGGUANGXIADEYUHUI12-3"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 504,
					conditionType = 1,
					preWaves = {
						503
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16694303,
							delay = 0,
							corrdinate = {
								-10,
								0,
								50
							},
							buffList = {
								201217
							}
						}
					}
				}
			}
		}
	},
	fleet_prefab = {
		vanguard_unitList = {
			{
				tmpID = 900479,
				configId = 900479,
				skinId = 402110,
				id = 1,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 300,
					air = 0,
					antiaircraft = 200,
					torpedo = 300,
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
						id = 150710,
						level = 10
					},
					{
						id = 150720,
						level = 10
					},
					{
						id = 30402,
						level = 10
					}
				}
			},
			{
				tmpID = 900480,
				configId = 900480,
				skinId = 401520,
				id = 2,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 20,
					air = 0,
					antiaircraft = 200,
					torpedo = 200,
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
						id = 150670,
						level = 10
					},
					{
						id = 150680,
						level = 10
					},
					{
						id = 150690,
						level = 10
					},
					{
						id = 30392,
						level = 10
					}
				}
			}
		},
		main_unitList = {
			{
				tmpID = 900482,
				configId = 900482,
				skinId = 407040,
				id = 1,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 300,
					air = 300,
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
						id = 150750,
						level = 10
					},
					{
						id = 150760,
						level = 10
					},
					{
						id = 150770,
						level = 10
					},
					{
						id = 151,
						level = 10
					},
					{
						id = 340,
						level = 10
					},
					{
						id = 201216,
						level = 2
					}
				}
			}
		}
	}
}
