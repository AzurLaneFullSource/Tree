return {
	map_id = 10001,
	id = 1819605,
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
						id = "HUANYINLAIDAOTONGXINXUEYUAN8-1"
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
							monsterTemplateID = 16625001,
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
							monsterTemplateID = 16625003,
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
							deadFX = "youeryuan_bomb",
							monsterTemplateID = 16625005,
							delay = 0,
							corrdinate = {
								-10,
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
							monsterTemplateID = 16625003,
							delay = 0,
							corrdinate = {
								-5,
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
							monsterTemplateID = 16625001,
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
							monsterTemplateID = 16625305,
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
							buffList = {},
							phase = {
								{
									switchParam = 1.5,
									switchTo = 1,
									index = 0,
									switchType = 1,
									setAI = 20006
								},
								{
									index = 1,
									switchType = 1,
									switchTo = 2,
									switchParam = 1,
									addWeapon = {
										3164401,
										3164402
									}
								},
								{
									index = 2,
									switchType = 1,
									switchTo = 3,
									switchParam = 7.5,
									addBuff = {
										200966
									}
								},
								{
									index = 3,
									switchType = 1,
									switchTo = 4,
									switchParam = 8,
									addBuff = {
										200967
									}
								},
								{
									index = 4,
									switchType = 1,
									switchTo = 5,
									switchParam = 2,
									removeWeapon = {
										3164401,
										3164402
									}
								},
								{
									index = 5,
									switchType = 1,
									switchTo = 6,
									switchParam = 2,
									addWeapon = {
										3164407,
										3164408
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 7,
									switchParam = 10,
									addBuff = {
										200968
									}
								},
								{
									index = 7,
									switchType = 1,
									switchTo = 8,
									switchParam = 10,
									addBuff = {
										200969
									}
								},
								{
									index = 8,
									switchType = 1,
									switchTo = 9,
									switchParam = 4,
									removeWeapon = {
										3164407,
										3164408
									}
								},
								{
									index = 9,
									switchType = 1,
									switchTo = 10,
									switchParam = 2,
									addWeapon = {
										3164415,
										3164416
									}
								},
								{
									index = 10,
									switchType = 1,
									switchTo = 11,
									switchParam = 4,
									addWeapon = {
										3164417
									}
								},
								{
									index = 11,
									switchType = 1,
									switchTo = 12,
									switchParam = 5.5,
									addWeapon = {
										3164418
									}
								},
								{
									index = 12,
									switchType = 1,
									switchTo = 1,
									switchParam = 2,
									removeWeapon = {
										3164415,
										3164416,
										3164417,
										3164418
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
						105
					},
					triggerParams = {}
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
				tmpID = 900440,
				configId = 900440,
				skinId = 102200,
				id = 2,
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
						id = 12240,
						level = 10
					},
					{
						id = 12250,
						level = 10
					},
					{
						id = 20142,
						level = 10
					}
				}
			},
			{
				tmpID = 900443,
				configId = 900443,
				skinId = 403120,
				id = 3,
				level = 20,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 350,
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
						id = 15540,
						level = 10
					},
					{
						id = 23212,
						level = 10
					}
				}
			}
		},
		main_unitList = {
			{
				tmpID = 900435,
				configId = 900435,
				skinId = 405060,
				id = 1,
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
					},
					{
						id = 200965,
						level = 10
					}
				}
			},
			{
				tmpID = 900438,
				configId = 900438,
				skinId = 207130,
				id = 2,
				level = 20,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 0,
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
						id = 16650,
						level = 10
					},
					{
						id = 16660,
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
