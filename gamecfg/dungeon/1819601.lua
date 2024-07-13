return {
	map_id = 10001,
	id = 1819601,
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
					waveIndex = 500,
					preWaves = {
						100
					},
					triggerParams = {
						id = "HUANYINLAIDAOTONGXINXUEYUAN3-1"
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
							deadFX = "youeryuan_bomb",
							monsterTemplateID = 16625002,
							delay = 0,
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
							deadFX = "youeryuan_bomb",
							monsterTemplateID = 16625001,
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
							deadFX = "youeryuan_bomb",
							monsterTemplateID = 16625003,
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
							deadFX = "youeryuan_bomb",
							monsterTemplateID = 16625001,
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
							deadFX = "youeryuan_bomb",
							monsterTemplateID = 16625002,
							delay = 0,
							corrdinate = {
								0,
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
					triggerType = 5,
					waveIndex = 400,
					preWaves = {
						101
					},
					triggerParams = {
						bgm = "votefes-up"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 105,
					conditionType = 0,
					preWaves = {
						101
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16625301,
							delay = 0.1,
							corrdinate = {
								-10,
								0,
								50
							},
							bossData = {
								hpBarNum = 100,
								icon = ""
							},
							buffList = {}
						}
					}
				},
				{
					triggerType = 8,
					waveIndex = 900,
					preWaves = {
						105
					},
					triggerParams = {}
				},
				{
					triggerType = 3,
					key = true,
					waveIndex = 501,
					preWaves = {
						900
					},
					triggerParams = {
						id = "HUANYINLAIDAOTONGXINXUEYUAN3-2"
					}
				}
			}
		}
	},
	fleet_prefab = {
		vanguard_unitList = {
			{
				tmpID = 900433,
				configId = 900433,
				skinId = 102210,
				id = 1,
				level = 20,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 200,
					air = 0,
					antiaircraft = 200,
					torpedo = 100,
					durability = 70000,
					reload = 300,
					armor = 0,
					dodge = 50,
					speed = 32,
					luck = 99,
					hit = 50
				},
				skills = {
					{
						id = 12260,
						level = 10
					},
					{
						id = 12270,
						level = 10
					},
					{
						id = 20132,
						level = 10
					}
				}
			},
			{
				tmpID = 900428,
				configId = 900428,
				skinId = 401431,
				id = 2,
				level = 20,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 150,
					air = 0,
					antiaircraft = 100,
					torpedo = 150,
					durability = 50000,
					reload = 300,
					armor = 0,
					dodge = 50,
					speed = 43,
					luck = 99,
					hit = 50
				},
				skills = {
					{
						id = 150180,
						level = 10
					},
					{
						id = 150190,
						level = 10
					},
					{
						id = 23052,
						level = 10
					}
				}
			},
			{
				tmpID = 900429,
				configId = 900429,
				skinId = 401471,
				id = 3,
				level = 20,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 150,
					air = 0,
					antiaircraft = 100,
					torpedo = 150,
					durability = 50000,
					reload = 300,
					armor = 0,
					dodge = 50,
					speed = 43,
					luck = 99,
					hit = 50
				},
				skills = {
					{
						id = 150160,
						level = 10
					},
					{
						id = 150170,
						level = 10
					},
					{
						id = 30282,
						level = 10
					}
				}
			}
		},
		main_unitList = {
			{
				tmpID = 900434,
				configId = 900434,
				skinId = 307130,
				id = 1,
				level = 20,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 100,
					air = 200,
					antiaircraft = 100,
					torpedo = 0,
					durability = 80000,
					reload = 600,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 50
				},
				skills = {
					{
						id = 16790,
						level = 10
					},
					{
						id = 16800,
						level = 10
					},
					{
						id = 200965,
						level = 10
					}
				}
			},
			{
				tmpID = 900435,
				configId = 900435,
				skinId = 405060,
				id = 2,
				level = 20,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 240,
					air = 0,
					antiaircraft = 100,
					torpedo = 0,
					durability = 80000,
					reload = 600,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 50
				},
				skills = {
					{
						id = 150120,
						level = 10
					},
					{
						id = 150130,
						level = 10
					}
				}
			},
			{
				tmpID = 900436,
				configId = 900436,
				skinId = 307140,
				id = 3,
				level = 20,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 100,
					air = 200,
					antiaircraft = 100,
					torpedo = 0,
					durability = 80000,
					reload = 600,
					armor = 0,
					dodge = 50,
					speed = 20,
					luck = 99,
					hit = 50
				},
				skills = {
					{
						id = 17920,
						level = 10
					},
					{
						id = 17930,
						level = 10
					}
				}
			}
		}
	}
}
