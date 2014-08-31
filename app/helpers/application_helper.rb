module ApplicationHelper
    def us_states
      [
        ['State:', ''],
        ['CA', 'CA'],
        ['AK', 'AK'],
        ['AL', 'AL'],
        ['AR', 'AR'],
        ['AZ', 'AZ'],
        ['CO', 'CO'],
        ['CT', 'CT'],
        ['DC', 'DC'],
        ['DE', 'DE'],
        ['FL', 'FL'],
        ['GA', 'GA'],
        ['HI', 'HI'],
        ['IA', 'IA'],
        ['ID', 'ID'],
        ['IL', 'IL'],
        ['IN', 'IN'],
        ['KS', 'KS'],
        ['KY', 'KY'],
        ['LA', 'LA'],
        ['MA', 'MA'],
        ['MD', 'MD'],
        ['ME', 'ME'],
        ['MI', 'MI'],
        ['MN', 'MN'],
        ['MO', 'MO'],
        ['MS', 'MS'],
        ['MT', 'MT'],
        ['NC', 'NC'],
        ['ND', 'ND'],
        ['NE', 'NE'],
        ['NH', 'NH'],
        ['NJ', 'NJ'],
        ['NM', 'NM'],
        ['NV', 'NV'],
        ['NY', 'NY'],
        ['OH', 'OH'],
        ['OK', 'OK'],
        ['OR', 'OR'],
        ['PA', 'PA'],
        ['RI', 'RI'],
        ['SC', 'SC'],
        ['SD', 'SD'],
        ['TN', 'TN'],
        ['TX', 'TX'],
        ['UT', 'UT'],
        ['VA', 'VA'],
        ['VT', 'VT'],
        ['WA', 'WA'],
        ['WI', 'WI'],
        ['WV', 'WV'],
        ['WY', 'WY']
      ]
    end

    def title(page_title, display_SF=true)
        if display_SF
            content_for :title, "Schools Fund - " + page_title
        else
            content_for :title, page_title
        end
    end

    def current_controller?(expected_controller)
        controller.controller_name == expected_controller
    end
end
