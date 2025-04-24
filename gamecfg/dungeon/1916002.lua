return {
	map_id = 10001,
	id = 1916002,
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
						id = "YANGQIYUJINZHIQI7-1"
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
							monsterTemplateID = 16726001,
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
							monsterTemplateID = 16726004,
							delay = 0,
							corrdinate = {
								-5,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16726005,
							delay = 0,
							corrdinate = {
								-5,
								0,
								45
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16726001,
							delay = 0,
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
							monsterTemplateID = 16726103,
							delay = 0,
							corrdinate = {
								0,
								0,
								55
							}
						},
						{
							monsterTemplateID = 16726002,
							delay = 0,
							corrdinate = {
								-5,
								0,
								65
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16726002,
							delay = 0,
							corrdinate = {
								-5,
								0,
								45
							},
							buffList = {
								8001,
								8007
							}
						},
						{
							monsterTemplateID = 16726001,
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
							monsterTemplateID = 16726001,
							delay = 0,
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
					waveIndex = 103,
					conditionType = 1,
					preWaves = {
						102
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16726104,
							delay = 0,
							corrdinate = {
								0,
								0,
								45
							}
						},
						{
							monsterTemplateID = 16726105,
							delay = 0,
							corrdinate = {
								0,
								0,
								65
							}
						},
						{
							monsterTemplateID = 16726003,
							delay = 0,
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
							monsterTemplateID = 16726002,
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
							monsterTemplateID = 16726002,
							delay = 0,
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
					triggerType = 3,
					waveIndex = 502,
					preWaves = {
						103
					},
					triggerParams = {
						id = "YANGQIYUJINZHIQI7-2"
					}
				},
				{
					triggerType = 1,
					waveIndex = 201,
					preWaves = {
						502
					},
					triggerParams = {
						timeout = 12
					}
				},
				{
					triggerType = 3,
					waveIndex = 503,
					preWaves = {
						201
					},
					triggerParams = {
						id = "YANGQIYUJINZHIQI7-3"
					}
				},
				{
					triggerType = 0,
					key = true,
					waveIndex = 104,
					conditionType = 1,
					preWaves = {
						502
					},
					triggerParam = {},
					spawn = {
						{
							monsterTemplateID = 16726202,
							delay = 0,
							sickness = 0.5,
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
									switchType = 1,
									switchTo = 1,
									index = 0,
									switchParam = 0.5,
									setAI = 20006,
									addWeapon = {
										3264001,
										3264003
									}
								},
								{
									switchType = 1,
									switchTo = 2,
									index = 1,
									switchParam = 8,
									setAI = 10001,
									addWeapon = {
										3264004,
										3264005
									}
								},
								{
									switchType = 1,
									switchTo = 3,
									index = 2,
									switchParam = 0.5,
									setAI = 75016,
									removeWeapon = {
										3264004,
										3264005
									}
								},
								{
									index = 3,
									switchType = 1,
									switchTo = 5,
									switchParam = 10,
									addWeapon = {
										3264006,
										3264007
									}
								},
								{
									index = 5,
									switchParam = 3,
									switchTo = 6,
									switchType = 1,
									addWeapon = {
										3264008
									},
									removeWeapon = {
										3264006,
										3264007
									}
								},
								{
									index = 6,
									switchType = 1,
									switchTo = 7,
									switchParam = 1,
									addWeapon = {
										3264009
									}
								},
								{
									index = 7,
									switchType = 1,
									switchTo = 8,
									switchParam = 1,
									addWeapon = {
										3264010
									}
								},
								{
									index = 8,
									switchType = 1,
									switchTo = 9,
									switchParam = 1,
									addWeapon = {
										3264011
									}
								},
								{
									index = 9,
									switchType = 1,
									switchTo = 10,
									switchParam = 1,
									addWeapon = {
										3264012
									}
								},
								{
									index = 10,
									switchType = 1,
									switchTo = 11,
									switchParam = 1,
									addWeapon = {
										3264013
									}
								},
								{
									index = 11,
									switchType = 1,
									switchTo = 12,
									switchParam = 1,
									addWeapon = {
										3264014
									}
								},
								{
									index = 12,
									switchType = 1,
									switchTo = 13,
									switchParam = 1,
									addWeapon = {
										3264015
									}
								},
								{
									index = 13,
									switchType = 1,
									switchTo = 14,
									switchParam = 5.5,
									addWeapon = {
										3264016
									}
								},
								{
									index = 14,
									switchType = 1,
									switchTo = 1,
									switchParam = 2,
									removeWeapon = {
										3264008,
										3264009,
										3264010,
										3264011,
										3264012,
										3264013,
										3264014,
										3264015,
										3264016
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
					waveIndex = 504,
					preWaves = {
						900
					},
					triggerParams = {
						id = "YANGQIYUJINZHIQI7-4"
					}
				}
			}
		}
	},
	fleet_prefab = {
		vanguard_unitList = {
			{
				tmpID = 900496,
				configId = 900496,
				skinId = 1102010,
				id = 1,
				level = 110,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 1500,
					air = 0,
					antiaircraft = 200,
					torpedo = 800,
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
						id = 151080,
						level = 10
					},
					{
						id = 151090,
						level = 10
					},
					{
						id = 30442,
						level = 10
					},
					{
						id = 201356,
						level = 2
					}
				}
			},
			{
				tmpID = 900497,
				configId = 900497,
				skinId = 1101010,
				id = 2,
				level = 110,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 1500,
					air = 0,
					antiaircraft = 200,
					torpedo = 800,
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
						id = 151040,
						level = 10
					},
					{
						id = 151050,
						level = 10
					},
					{
						id = 250012,
						level = 10
					}
				}
			},
			{
				tmpID = 900451,
				configId = 900451,
				skinId = 102160,
				id = 3,
				level = 110,
				equipment = {
					false,
					false,
					false
				},
				properties = {
					cannon = 1500,
					air = 0,
					antiaircraft = 200,
					torpedo = 800,
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
						id = 2001,
						level = 10
					},
					{
						id = 20112,
						level = 10
					}
				}
			}
		},
		main_unitList = {}
	}
}
