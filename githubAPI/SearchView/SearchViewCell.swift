//
//  SearchViewCell.swift
//  githubAPI
//
//  Created by 정진균 on 2021/12/03.
//

import UIKit
import SnapKit

class SearchViewCell: UITableViewCell {
    
    var cellImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "test")
        return img
    }()
    
    var cellLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "test"
        return lb
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellImage)
        contentView.addSubview(cellLabel)
        
        cellImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(40)
        }
        
        cellLabel.snp.makeConstraints { make in
            make.leading.equalTo(cellImage.snp.trailing).offset(20)
            make.top.equalTo(cellImage.snp.top)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
