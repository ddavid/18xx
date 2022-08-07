# frozen_string_literal: true

module Engine
  module Game
    module G1894
      module Entities
        COMPANIES = [
          {
            name: 'Ligne Longwy-Villerupt-Micheville',
            sym: 'LVM',
            value: 20,
            revenue: 5,
            desc: 'Owning corporation may lay a yellow tile in I14.'\
                  ' This is in addition to the corporation\'s tile builds.'\
                  ' No connection required. Blocks I14 while owned by a player.',
            abilities: [{ type: 'blocks_hexes', owner_type: 'player', hexes: ['I14'] },
                        {
                          type: 'tile_lay',
                          owner_type: 'corporation',
                          hexes: ['I14'],
                          tiles: %w[7 8 9],
                          when: 'owning_corp_or_turn',
                          count: 1,
                        }],
          },
          {
            name: 'Gare de Liège-Guillemins',
            sym: 'GLG',
            value: 50,
            revenue: 10,
            desc: 'Owning corporation may lay a yellow tile or upgrade a yellow tile in Liège'\
                  ' (H17) along with an optional station marker.'\
                  ' This counts as one of the corporation\'s tile builds.'\
                  ' Blocks H17 while owned by a player.',
            abilities: [{ type: 'blocks_hexes', owner_type: 'player', hexes: ['H17'] },
                        {
                          type: 'teleport',
                          owner_type: 'corporation',
                          hexes: ['H17'],
                          tiles: %w[14 15 57 619],
                        }],
          },
          {
            name: 'London shipping',
            sym: 'LS',
            value: 90,
            revenue: 15,
            desc: 'Owning corporation may place one of its tokens for free in A12.'\
                  ' The value of London (A10) is increased, for this corporation only,'\
                  ' by the largest other revenue on the route.',
            abilities: [{
              type: 'token',
              when: 'owning_corp_or_turn',
              hexes: ['A12'],
              count: 1,
              extra_action: true,
              from_owner: true,
              owner_type: 'corporation',
            }]
          },
          {
            name: 'Ligne de Saint-Quentin à Guise',
            sym: 'SQG',
            value: 100,
            desc: 'Revenue is equal to 70 if Saint-Quentin (G10) is green, to 100 if Saint-Quentin is brown and to 0 otherwise.'\
                  ' Closes in purple phase.',
            abilities: [{ type: 'close', on_phase: 'Purple' },],
          },        
          {
            name: 'Nord minor shareholding',
            sym: 'NMS',
            value: 140,
            revenue: 20,
            desc: 'Owning player immediately receives a 10% share of the Nord without further payment.',
            abilities: [{ type: 'shares', shares: 'Nord_1' },],
          },
          {
            name: 'PLM major shareholding',
            sym: 'PLMMS',
            value: 180,
            revenue: 25,
            desc: 'Owning player immediately receives the President\'s certificate of the'\
                  ' PLM without further payment. This private company may not be sold to any corporation, and does'\
                  ' not exchange hands if the owning player loses the Presidency of the PLM.'\
                  ' Closes when the PLM operates.',
            abilities: [{ type: 'close', when: 'operated', corporation: 'PLM' },
                        { type: 'no_buy' },
                        { type: 'shares', shares: 'PLM_0' }],
          },
          {
            name: 'Belge major shareholding',
            sym: 'BMS',
            value: 300,
            revenue: 30,
            desc: 'Owning player immediately receives the President\'s certificate and a 10% share of the'\
                  ' Belge without further payment. This private company may not be sold to any corporation, and does'\
                  ' not exchange hands if the owning player loses the Presidency of the Belge.'\
                  ' Closes when the Belge operates.',
            abilities: [{ type: 'close', when: 'operated', corporation: 'Belge' },
                        { type: 'no_buy' },
                        { type: 'shares', shares: 'Belge_0' }],
          },
        ].freeze

        CORPORATIONS = [
          {
            sym: 'Ouest',
            name: 'Chemins de fer de l\'Ouest',
            logo: '1894/Ouest',
            simple_logo: '1894/Ouest.alt',
            tokens: [0, 0, 80, 80, 120],
            max_ownership_percent: 60,
            coordinates: %w[B3 E6],
            color: '#4682b4',
            abilities: [
              {
                type: 'base',
                description: 'Two home stations (Le Havre and Amiens)',
              },
            ],
          },
          {
            sym: 'Nord',
            name: 'Chemins de fer du Nord',
            logo: '1894/Nord',
            simple_logo: '1894/Nord.alt',
            tokens: [0, 0, 80, 80, 120],
            max_ownership_percent: 60,
            coordinates: %w[E10 G14],
            color: '#ff4040',
            abilities: [
              {
                type: 'base',
                description: 'Two home stations (Rouen and Lille)',
              },
            ],
          },
          {
            sym: 'GR',
            name: 'Gent Railway',
            logo: '1894/GR',
            simple_logo: '1894/GR.alt',
            tokens: [0, 40, 80, 80],
            max_ownership_percent: 60,
            coordinates: 'D15',
            color: '#fcf75e',
            text_color: 'black',
          },
          {
            sym: 'CAB',
            name: 'Chemins de fer d\'Amiens à Boulogne',
            logo: '1894/CAB',
            simple_logo: '1894/CAB.alt',
            tokens: [0, 0, 80, 80, 120],
            max_ownership_percent: 60,
            coordinates: %w[D3 H1],
            color: '#9c661f',
          },
          {
            sym: 'Belge',
            name: 'Chemins de fer de l\'État belge',
            logo: '1894/Belge',
            simple_logo: '1894/Belge.alt',
            tokens: [0, 40, 80],
            max_ownership_percent: 60,
            coordinates: 'D17',
            color: '#61b229',
          },
          {
            sym: 'PLM',
            name: 'Chemins de fer de Paris à Lyon et à la Méditerranée',
            logo: '1894/PLM',
            simple_logo: '1894/PLM.alt',
            tokens: [0, 40, 80, 80, 120],
            max_ownership_percent: 60,
            coordinates: 'G4',
            city: 0,
            color: '#dda0dd',
            text_color: 'black',
          },
          {
            sym: 'Est',
            name: 'Chemins de fer de l\'Est',
            logo: '1894/Est',
            simple_logo: '1894/Est.alt',
            tokens: [0, 40, 40, 40, 40],
            max_ownership_percent: 60,
            coordinates: 'I8',
            color: '#ff9966',
            text_color: 'black',
            abilities: [
              {
                type: 'hex_bonus',
                amount: 0,
                description: 'Value of Le Sud (I2) increased by 30.',
                hexes: ['I2'],
              },
            ],
          },
          {
            sym: 'F1',
            name: 'French 1',
            logo: '1894/F1',
            simple_logo: '1894/F1.alt',
            tokens: [0, 40],
            max_ownership_percent: 60,
            color: '#ffc0cb',
            text_color: 'black',
            abilities: [
              {
                type: 'description',
                description: 'Home in an empty hex in France',
              },
            ],
          },
          # {
          #   sym: 'F2',
          #   name: 'French 2',
          #   logo: '1894/F2',
          #   simple_logo: '1894/F2.alt',
          #   tokens: [0, 40],
          #   max_ownership_percent: 60,
          #   color: 'lime',
          #   text_color: 'black',
          #   abilities: [
          #     {
          #       type: 'description',
          #       description: 'Home in an empty hex in France',
          #     },
          #   ],
          # },
          {
            sym: 'B1',
            name: 'Belgian 1',
            logo: '1894/B1',
            simple_logo: '1894/B1.alt',
            tokens: [0, 40],
            max_ownership_percent: 60,
            color: '#c9c9c9',
            text_color: 'black',
            abilities: [
              {
                type: 'description',
                description: 'Home in an empty hex in Belgium',
              },
            ],
          },
          # {
          #   sym: 'B2',
          #   name: 'Belgian 2',
          #   logo: '1894/B2',
          #   simple_logo: '1894/B2.alt',
          #   tokens: [0, 40],
          #   max_ownership_percent: 60,
          #   color: '#ffefdb',
          #       type: 'description',
          #       description: 'Home in an empty hex in Belgium',
          #     },
          #   ],
          # },
        ].freeze
      end
    end
  end
end
