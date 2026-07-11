import '../models/paper.dart';

class SubjectDef {
  final String displayName;
  final String directoryName;
  final List<Paper> papers;

  const SubjectDef({
    required this.displayName,
    required this.directoryName,
    required this.papers,
  });
}

class AssetRegistry {
  static const subjects = [
    SubjectDef(
      displayName: 'Pathology',
      directoryName: 'Pathology',
      papers: [
        Paper(
          name: 'Paper 1',
          directoryName: 'paper1',
          csvFiles: [
            'Cell Injury, Cell Death and Adaptations.csv',
            'Environmental and Nutritional Disorders.csv',
            'Genetic disorders.csv',
            'Hemodynamic Disorders, Thromboembolism and Shock.csv',
            'Immunology.csv',
            'Infancy and Diseases of Childhood.csv',
            'Infectious Diseases.csv',
            'Inflammation and Repair.csv',
            'Neoplasia.csv',
            'Platelets.csv',
            'Red Blood Cells.csv',
            'The Cell as a Unit of Health and Disease.csv',
            'White Blood Cells.csv',
          ],
        ),
        Paper(
          name: 'Paper 2',
          directoryName: 'paper2',
          csvFiles: [
            'Blood Vessels.csv',
            'Bones, Joints and Soft Tissue Tumors.csv',
            'Breast.csv',
            'Central Nervous System.csv',
            'Endocrinology.csv',
            'Female Genital Tract.csv',
            'Gastrointestinal System.csv',
            'Head and Neck.csv',
            'Heart.csv',
            'Kidney.csv',
            'Liver, Gall bladder and Pancreas.csv',
            'Male Genital Tract.csv',
            'Respiratory System.csv',
            'Skin.csv',
          ],
        ),
      ],
    ),
    SubjectDef(
      displayName: 'Pharmacology',
      directoryName: 'Pharmacology',
      papers: [
        Paper(
          name: 'Paper 1',
          directoryName: 'paper1',
          csvFiles: [
            'Autacoids.csv',
            'Autonomic Nervous System.csv',
            'Cardiovascular System.csv',
            'Central Nervous System.csv',
            'General Pharmacology.csv',
            'Peripheral Nervous System.csv',
            'Respiratory System.csv',
          ],
        ),
        Paper(
          name: 'Paper 2',
          directoryName: 'paper2',
          csvFiles: [
            'Anti-Microbial Drugs.csv',
            'Gastrointestinal System.csv',
            'Hormones.csv',
            'Miscellaneous Drugs.csv',
            'Neoplastic Drugs.csv',
          ],
        ),
      ],
    ),
    SubjectDef(
      displayName: 'Microbiology',
      directoryName: 'Microbiology',
      papers: [
        Paper(
          name: 'Paper 1',
          directoryName: 'paper1',
          csvFiles: [
            'General Microbiology.csv', 
            'Hospital Infection Control.csv', 
            'Immunology.csv', 
            'Miscellaneous Bacteria and Microbial Zoonotic diseases.csv', 
            'Skin, Soft tissues and Musculoskeletal System Infections.csv',
          ],
        ),
        Paper(
          name: 'Paper 2',
          directoryName: 'paper2',
          csvFiles: [
            'Bloodstream and Cardiovascular Infections.csv', 
            'Central Nervous System Infections.csv', 
            'Gastrointestinal Infections.csv', 
            'Genito-Urinary and Sexually Transmitted Infections.csv', 
            'Hepatobiliary Infections.csv', 
            'Respiratory Tract Infections.csv',
          ],
        ),
      ],
    ),
  ];

  static String assetPath(String subjectDir, String paperDir, String fileName) {
    return 'assets/questions/$subjectDir/$paperDir/$fileName';
  }
}
