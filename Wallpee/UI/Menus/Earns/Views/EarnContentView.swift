//
//  EarnContentView.swift
//  Wallpee
//
//  Created by Thanh Hoang on 20/6/24.
//

import UIKit

class EarnContentView: UIView {
    
    //MARK: - UIView
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let wheelBGImageView = UIImageView()
    
    let sepView_1 = UIView()
    let titleLbl = UILabel()
    let sepView_2 = UIView()
    
    let wheelView = UIView()
    let wheelCircleImageView = UIImageView()
    
    var wheelControl: SwiftFortuneWheel!
    
    let pointerView = UIImageView()
    
    let spinView = UIView()
    let spinBGImageView = UIImageView()
    let spinActView = ViewAnimation()
    let spinActImageView = UIImageView()
    let spinActLbl = UILabel()
    
    var earnVC: EarnVC?
    
    //MARK: - Properties
    lazy var items: [W_DailyRewards] = []
    
    lazy var prizes = [
        (name: "", color: #colorLiteral(red: 0.9843137255, green: 0.5490196078, blue: 0, alpha: 1), imageName: "earn-1", textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), type: "+1"),
        (name: "", color: #colorLiteral(red: 0.8828339577, green: 0.3921767175, blue: 0.4065475464, alpha: 1), imageName: "earn-crying", textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), type: "crying"),
        (name: "", color: #colorLiteral(red: 0.8980392157, green: 0.2235294118, blue: 0.2078431373, alpha: 1), imageName: "earn-spin", textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), type: "spin"),
        (name: "", color: #colorLiteral(red: 0, green: 0.6745098039, blue: 0.7568627451, alpha: 1), imageName: "earn-crying", textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), type: "crying"),
        (name: "", color: #colorLiteral(red: 0.2039215686, green: 0.3019607843, blue: 0.3882352941, alpha: 1), imageName: "earn-1", textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), type: "+1"),
        (name: "", color: #colorLiteral(red: 0, green: 0.6745098039, blue: 0.7568627451, alpha: 1), imageName: "earn-crying", textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), type: "crying"),
        (name: "", color: #colorLiteral(red: 0.4862745098, green: 0.7019607843, blue: 0.2588235294, alpha: 1), imageName: "earn-10", textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), type: "+10"),
        (name: "", color: #colorLiteral(red: 0.07058823529, green: 0.6196078431, blue: 0.5450980392, alpha: 1), imageName: "earn-crying", textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), type: "crying"),
        (name: "", color: #colorLiteral(red: 0.3255994916, green: 0.7100547552, blue: 0.9348809719, alpha: 1), imageName: "earn-spin", textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), type: "spin"),
        (name: "", color: #colorLiteral(red: 0.3287895918, green: 0.3738358617, blue: 0.8356924653, alpha: 1), imageName: "earn-crying", textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), type: "crying"),
        (name: "", color: #colorLiteral(red: 0.1607843137, green: 0.4980392157, blue: 0.7215686275, alpha: 1), imageName: "earn-1", textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), type: "+1"),
        (name: "", color: #colorLiteral(red: 0.5607843137, green: 0.2509803922, blue: 0.4274509804, alpha: 1), imageName: "earn-crying", textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), type: "crying"),
    ]
    
    lazy var slices: [Slice] = {
        var slices: [Slice] = []
        for prize in prizes {
            let sliceContent = [
                Slice.ContentType.assetImage(name: prize.imageName, preferences: .variousWheelPodiumImage),
                Slice.ContentType.text(text: prize.name, preferences: .variousWheelPodiumText(textColor: prize.textColor))
            ]
            var slice = Slice(contents: sliceContent, backgroundColor: prize.color, type: prize.type)
            slices.append(slice)
        }
        return slices
    }()
    
    var finishIndex: Int {
        return Int.random(in: 0..<wheelControl.slices.count)
    }
    
    //Mỗi ngày đc 3 lần Quay
    var spinLimit: Int {
        return KeyManager.shared.getSpin() ?? 0
    }
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension EarnContentView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .clear
        
        let panelImage = UIImage(named: "panel-\(appDL.currentLanguage.code)")!
        
        let cvHeight = (EarnVC.itemH*3) + 20
        let wheelW = screenWidth*0.9
        let wheelH = wheelW * (panelImage.size.height/panelImage.size.width)
        
        //TODO: - CollectionView
        collectionView.isScrollEnabled = false
        collectionView.clipsToBounds = true
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = true
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(EarnContentCVCell.self, forCellWithReuseIdentifier: EarnContentCVCell.id)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: cvHeight).isActive = true
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        layout.scrollDirection = .vertical
        
        //TODO: - WheelBGImageView
        wheelBGImageView.clipsToBounds = true
        wheelBGImageView.image = panelImage
        wheelBGImageView.contentMode = .scaleAspectFit
        wheelBGImageView.translatesAutoresizingMaskIntoConstraints = false
        wheelBGImageView.widthAnchor.constraint(equalToConstant: wheelW).isActive = true
        wheelBGImageView.heightAnchor.constraint(equalToConstant: wheelH).isActive = true
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.montExtraBold, size: screenWidth * 0.055)
        titleLbl.textAlignment = .center
        titleLbl.text = "Daily Rewards".localized()
        titleLbl.sizeToFit()
        
        let titleGr = createGradient(
            bounds: titleLbl.bounds,
            startPoint: CGPoint(x: 0.0, y: 0.5),
            endPoint: CGPoint(x: 1.0, y: 0.5)
        )
        titleLbl.textColor = convertGradientToColor(gradient: titleGr)
        
        //TODO: - SepView_1
        let sepW = (screenWidth - 60 - titleLbl.frame.width)/2
        
        sepView_1.clipsToBounds = true
        sepView_1.backgroundColor = UIColor(hex: 0xF49000)
        sepView_1.translatesAutoresizingMaskIntoConstraints = false
        sepView_1.widthAnchor.constraint(equalToConstant: sepW).isActive = true
        sepView_1.heightAnchor.constraint(equalToConstant: 5.0).isActive = true
        
        //TODO: - SepView_2
        sepView_2.clipsToBounds = true
        sepView_2.backgroundColor = UIColor(hex: 0xF49000)
        sepView_2.translatesAutoresizingMaskIntoConstraints = false
        sepView_2.widthAnchor.constraint(equalToConstant: sepW).isActive = true
        sepView_2.heightAnchor.constraint(equalToConstant: 5.0).isActive = true
        
        //TODO: - UIStackView
        let titleSV = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .center)
        titleSV.addArrangedSubview(sepView_1)
        titleSV.addArrangedSubview(titleLbl)
        titleSV.addArrangedSubview(sepView_2)
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 30.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(wheelBGImageView)
        stackView.addArrangedSubview(titleSV)
        stackView.addArrangedSubview(collectionView)
        addSubview(stackView)
        
        //TODO: - WheelView
        wheelView.clipsToBounds = false
        wheelView.backgroundColor = .clear
        addSubview(wheelView)
        wheelView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - WheelCircleImageView
        wheelCircleImageView.clipsToBounds = true
        wheelCircleImageView.image = UIImage(named: "circleGradient")
        wheelCircleImageView.contentMode = .scaleAspectFit
        wheelView.addSubview(wheelCircleImageView)
        wheelCircleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - WheelControl
        let wheelRect = CGRect(x: 12.0, y: 12.0, width: wheelW-24, height: wheelW-24)
        wheelControl = SwiftFortuneWheel(frame: wheelRect, slices: slices, configuration: .variousWheelPodiumConfiguration)
        //wheelControl.spinImage = "centerImage"
        wheelControl.edgeCollisionSound = AudioFile(filename: "Click", extensionName: "mp3")
        wheelControl.isSpinEnabled = false
        wheelControl.edgeCollisionDetectionOn = true
        wheelView.addSubview(wheelControl)
        
        //TODO: - PointerView
        pointerView.clipsToBounds = true
        pointerView.image = UIImage(named: "pin")
        pointerView.contentMode = .scaleAspectFit
        wheelView.addSubview(pointerView)
        pointerView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - RotateView
        spinView.clipsToBounds = false
        spinView.backgroundColor = .clear
        addSubview(spinView)
        spinView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SpinImageView
        spinBGImageView.clipsToBounds = true
        spinBGImageView.image = UIImage(named: "btn-spinBG")
        spinBGImageView.contentMode = .scaleAspectFit
        spinView.addSubview(spinBGImageView)
        spinBGImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SpinActView
        spinActView.clipsToBounds = true
        spinActView.delegate = self
        spinView.addSubview(spinActView)
        spinActView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SpinActImageView
        spinActImageView.clipsToBounds = true
        spinActImageView.image = UIImage(named: "btn-spin")
        spinActImageView.contentMode = .scaleAspectFit
        spinActView.addSubview(spinActImageView)
        spinActImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - SpinActLbl
        spinActLbl.font = UIFont(name: FontName.montExtraBold, size: 14.0)
        spinActLbl.textColor = UIColor(hex: 0xBD6E00)
        spinActLbl.textAlignment = .center
        spinActLbl.numberOfLines = 2
        spinActLbl.adjustsFontSizeToFitWidth = true
        spinActView.addSubview(spinActLbl)
        spinActLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0),
            
            wheelView.widthAnchor.constraint(equalToConstant: wheelW),
            wheelView.heightAnchor.constraint(equalToConstant: wheelW),
            wheelView.centerXAnchor.constraint(equalTo: wheelBGImageView.centerXAnchor),
            wheelView.bottomAnchor.constraint(equalTo: wheelBGImageView.bottomAnchor),
            
            wheelCircleImageView.heightAnchor.constraint(equalToConstant: wheelW),
            wheelCircleImageView.widthAnchor.constraint(equalToConstant: wheelW),
            wheelCircleImageView.centerXAnchor.constraint(equalTo: wheelView.centerXAnchor),
            wheelCircleImageView.bottomAnchor.constraint(equalTo: wheelView.bottomAnchor),
            
            pointerView.heightAnchor.constraint(equalToConstant: wheelW),
            pointerView.widthAnchor.constraint(equalToConstant: wheelW),
            pointerView.centerXAnchor.constraint(equalTo: wheelView.centerXAnchor),
            pointerView.bottomAnchor.constraint(equalTo: wheelView.bottomAnchor),
            
            spinView.widthAnchor.constraint(equalToConstant: wheelW*0.28),
            spinView.heightAnchor.constraint(equalTo: spinView.widthAnchor, multiplier: 1.0),
            spinView.centerXAnchor.constraint(equalTo: wheelView.centerXAnchor),
            spinView.centerYAnchor.constraint(equalTo: wheelView.centerYAnchor),
            
            spinBGImageView.topAnchor.constraint(equalTo: spinView.topAnchor),
            spinBGImageView.leadingAnchor.constraint(equalTo: spinView.leadingAnchor),
            spinBGImageView.trailingAnchor.constraint(equalTo: spinView.trailingAnchor),
            spinBGImageView.bottomAnchor.constraint(equalTo: spinView.bottomAnchor),
            
            spinActView.topAnchor.constraint(equalTo: spinView.topAnchor),
            spinActView.leadingAnchor.constraint(equalTo: spinView.leadingAnchor),
            spinActView.trailingAnchor.constraint(equalTo: spinView.trailingAnchor),
            spinActView.bottomAnchor.constraint(equalTo: spinView.bottomAnchor),
            
            spinActImageView.topAnchor.constraint(equalTo: spinActView.topAnchor),
            spinActImageView.leadingAnchor.constraint(equalTo: spinActView.leadingAnchor),
            spinActImageView.trailingAnchor.constraint(equalTo: spinActView.trailingAnchor),
            spinActImageView.bottomAnchor.constraint(equalTo: spinActView.bottomAnchor),
            
            spinActLbl.widthAnchor.constraint(equalToConstant: wheelW * (113/222)),
            spinActLbl.heightAnchor.constraint(equalTo: spinActLbl.widthAnchor, multiplier: 1.0),
            spinActLbl.centerXAnchor.constraint(equalTo: spinActView.centerXAnchor),
            spinActLbl.centerYAnchor.constraint(equalTo: spinActView.centerYAnchor),
        ])
        
        updateSpinLbl()
        enabledSpin()
    }
    
    func setupDataSourceAndDelegate(dl: UICollectionViewDataSource & UICollectionViewDelegate) {
        items = CoreDataStack.fetchDailyRewards()
        
        collectionView.dataSource = dl
        collectionView.delegate = dl
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func updateSpinLbl() {
        var txt = ""
        if spinLimit > 0 {
            txt = "\n" + "(\(spinLimit))"
        }
        
        spinActLbl.text = "Spin".localized().uppercased() + txt
    }
    
    private func enabledSpin() {
        spinActView.alpha = spinLimit <= 0 ? 0.4 : 1.0
        spinActView.isUserInteractionEnabled = spinLimit > 0
    }
}

//MARK: - UICollectionViewDataSource

extension EarnContentView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EarnContentCVCell.id, for: indexPath) as! EarnContentCVCell
        
        if items.count > 0 && indexPath.item < items.count {
            let item = items[indexPath.item]
            cell.updateUI(item: item)
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension EarnContentView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        
        let f = createDateFormatter()
        f.dateFormat = "yyyyMMdd"
        
        let time = f.string(from: Date())
        let currentTime = item.createdTime == time
        
        if currentTime && !item.earn {
            item.earn = true
            items[indexPath.item].earn = true
            
            if let type = DailyRewardsType(rawValue: item.type) {
                CoreDataStack.updateDailyRewards(type: type)
                
                if let cell = collectionView.cellForItem(at: indexPath) as? EarnContentCVCell {
                    cell.updateUI(item: item)
                }
                
                let coin = (KeyManager.shared.getCoin() ?? 0) + item.coin.intValue
                KeyManager.shared.setCoin(coin: coin)
                
                /*
                 - Cho lần đầu nhấn vào Daily Rewards
                 - Nếu người dùng xóa App, cài đặt lại
                 - Cần nhấn phần thưởng ngay
                 - Ko cần đợi đến 7h sáng
                 */
                KeyManager.shared.setDailyRewards()
                
                let hud = HUD.hud(kWindow, text: "+\(item.coin.intValue)", image: UIImage(named: "icon-coin"), earnCoin: true)
                hud.isUserInteractionEnabled = true
                
                delay(duration: 0.5) {
                    hud.removeHUD {}
                }
                
                NotificationCenter.default.post(name: .updateMenuIconKey, object: nil)
            }
            
        } else {
            print("NULL")
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension EarnContentView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: EarnVC.itemW, height: EarnVC.itemH)
    }
}

//MARK: - ViewAnimationDelegate

extension EarnContentView: ViewAnimationDelegate {
    
    func viewAnimationDidTap(_ sender: ViewAnimation) {
        if spinLimit <= 0 {
            return
        }
        
        earnVC?.view.isUserInteractionEnabled = false
        
        KeyManager.shared.updateSpin(spin: spinLimit-1)
        
        updateSpinLbl()
        spinActView.alpha = 0.4
        
        if spinLimit <= 0 {
            spinActLbl.text = "Spin".localized().uppercased()
        }
        
        wheelControl.startRotationAnimation(finishIndex: finishIndex, continuousRotationTime: 1) { (finished, index) in
            if finished {
                let type = self.prizes[index].type
                var icon: UIImage?
                
                if type == "+1" {
                    icon = UIImage(named: "earn-1")
                    
                    let coin = (KeyManager.shared.getCoin() ?? 0) + 1
                    KeyManager.shared.setCoin(coin: coin)
                    
                } else if type == "+10" {
                    icon = UIImage(named: "earn-10")
                    
                    let coin = (KeyManager.shared.getCoin() ?? 0) + 10
                    KeyManager.shared.setCoin(coin: coin)
                    
                } else if type == "spin" {
                    icon = UIImage(named: "earn-spin")
                    KeyManager.shared.updateSpin(spin: self.spinLimit+1)
                    self.updateSpinLbl()
                    
                } else if type == "crying" {
                    icon = UIImage(named: "earn-crying")
                }
                
                let hud = HUD.hud(kWindow, image: icon, dailyReward: true)
                hud.isUserInteractionEnabled = true
                
                delay(duration: 0.5) {
                    hud.removeHUD {}
                }
            }
            
            self.enabledSpin()
            
            self.earnVC?.view.isUserInteractionEnabled = true
            
            NotificationCenter.default.post(name: .updateMenuIconKey, object: nil)
        }
    }
}
