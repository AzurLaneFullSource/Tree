return {
	id = 1360004,
	stages = {
		{
			stageIndex = 1,
			failCondition = 1,
			timeCount = 300,
			passCondition = 1,
			backGroundStageID = 1,
			totalArea = {
				-75,
				20,
				90,
				70
			},
			playerArea = {
				-75,
				20,
				42,
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
					triggerType = 1,
					waveIndex = 200,
					preWaves = {
						100
					},
					triggerParams = {
						timeout = 10
					}
				},
				{
					triggerType = 3,
					waveIndex = 201,
					conditionType = 1,
					preWaves = {
						200
					},
					triggerParams = {
						id = "BULIZHANDUIDAPOGANGQUWEIJI3-1"
					}
				},
				{
					triggerType = 4,
					waveIndex = 202,
					preWaves = {
						201
					},
					triggerParams = {
						kill_list = {
							900494
						}
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
							monsterTemplateID = 13400008,
							delay = 0,
							corrdinate = {
								10,
								0,
								72
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 13400009,
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
							monsterTemplateID = 13400010,
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
							monsterTemplateID = 13400009,
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
						},
						{
							monsterTemplateID = 13400008,
							delay = 0,
							corrdinate = {
								10,
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
					triggerType = 1,
					waveIndex = 203,
					preWaves = {
						101
					},
					triggerParams = {
						timeout = 10
					}
				},
				{
					triggerType = 3,
					waveIndex = 204,
					conditionType = 1,
					preWaves = {
						203
					},
					triggerParams = {
						id = "BULIZHANDUIDAPOGANGQUWEIJI3-2"
					}
				},
				{
					triggerType = 4,
					waveIndex = 205,
					preWaves = {
						204
					},
					triggerParams = {
						kill_list = {
							900493
						}
					}
				},
				{
					triggerType = 1,
					waveIndex = 301,
					preWaves = {
						101
					},
					triggerParams = {
						timeout = 3
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 102,
					conditionType = 1,
					preWaves = {
						301
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 13400009,
							delay = 0,
							corrdinate = {
								10,
								0,
								72
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 13400010,
							delay = 0,
							corrdinate = {
								-5,
								0,
								62
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 13400008,
							delay = 0,
							corrdinate = {
								5,
								0,
								52
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 13400010,
							delay = 0,
							corrdinate = {
								-5,
								0,
								42
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 13400009,
							delay = 0,
							corrdinate = {
								10,
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
					triggerType = 1,
					waveIndex = 302,
					preWaves = {
						102
					},
					triggerParams = {
						timeout = 3
					}
				},
				{
					triggerType = 1,
					waveIndex = 206,
					preWaves = {
						302
					},
					triggerParams = {
						timeout = 0.5
					}
				},
				{
					triggerType = 3,
					waveIndex = 207,
					conditionType = 1,
					preWaves = {
						206
					},
					triggerParams = {
						id = "BULIZHANDUIDAPOGANGQUWEIJI3-3"
					}
				},
				{
					triggerType = 0,
					waveIndex = 103,
					conditionType = 1,
					preWaves = {
						302
					},
					triggerParams = {},
					spawn = {
						{
							monsterTemplateID = 13400011,
							delay = 0,
							corrdinate = {
								-10,
								0,
								50
							},
							buffList = {
								201354
							},
							bossData = {
								hpBarNum = 100,
								icon = ""
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
									switchTo = 0,
									index = 1,
									switchParam = 300,
									setAI = 70252,
									addWeapon = {
										630085
									},
									removeWeapon = {}
								}
							}
						}
					}
				},
				{
					triggerType = 8,
					key = true,
					waveIndex = 900,
					preWaves = {
						103
					},
					triggerParams = {}
				},
				{
					triggerType = 3,
					key = true,
					waveIndex = 104,
					conditionType = 1,
					preWaves = {
						900
					},
					triggerParams = {
						id = "BULIZHANDUIDAPOGANGQUWEIJI3-4"
					}
				}
			}
		}
	},
	fleet_prefab = {
		vanguard_unitList = {
			{
				tmpID = 900495,
				configId = 900495,
				skinId = 100020,
				id = 1,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 1,
					air = 0,
					antiaircraft = 200,
					torpedo = 1,
					durability = 77777,
					reload = 300,
					armor = 0,
					dodge = 300,
					speed = 35,
					luck = 100,
					hit = 140
				},
				skills = {
					{
						id = 201351,
						level = 1
					}
				}
			},
			{
				tmpID = 900493,
				configId = 900493,
				skinId = 100000,
				id = 2,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 1,
					air = 0,
					antiaircraft = 200,
					torpedo = 1,
					durability = 77777,
					reload = 300,
					armor = 0,
					dodge = 300,
					speed = 35,
					luck = 100,
					hit = 140
				},
				skills = {}
			},
			{
				tmpID = 900494,
				configId = 900494,
				skinId = 100010,
				id = 3,
				level = 125,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 1,
					air = 0,
					antiaircraft = 200,
					torpedo = 1,
					durability = 77777,
					reload = 300,
					armor = 0,
					dodge = 300,
					speed = 35,
					luck = 100,
					hit = 140
				},
				skills = {}
			}
		}
	}
}
