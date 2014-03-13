/*Initial database creation*/
CREATE DATABASE  IF NOT EXISTS `clubuml`;
USE `clubuml`;

/*Cleanup of any existing tables*/
DROP TABLE IF EXISTS `project`;
DROP TABLE IF EXISTS `user`;
DROP TABLE IF EXISTS `userproject`;
DROP TABLE IF EXISTS `report`;
DROP TABLE IF EXISTS `diagramContext`;
DROP TABLE IF EXISTS `compare`;
DROP TABLE IF EXISTS 'rationale'

/*legacy*/
DROP TABLE IF EXISTS `metric`;
DROP TABLE IF EXISTS `metricType`;
DROP TABLE IF EXISTS `diagramMetricsScore`;
DROP TABLE IF EXISTS `attributes`;
DROP TABLE IF EXISTS `classes`;
DROP TABLE IF EXISTS `diagramPolicyScore`;
DROP TABLE IF EXISTS `comment`;


/*Table Creation*/

-- Table project
CREATE TABLE project
(
    projectId Int(11) NOT NULL AUTO_INCREMENT,
    projectName Varchar(45) NOT NULL UNIQUE,
    startDate Timestamp NOT NULL,
    description Varchar(255),
    enabled BOOLEAN NOT NULL DEFAULT true,
    disabledDate Timestamp,
    PRIMARY KEY (projectId)
);

-- Table user
CREATE TABLE user
(
    userId Int(11) NOT NULL AUTO_INCREMENT,
    userName Varchar(45) NOT NULL UNIQUE,
    email Varchar(45) NOT NULL,
    password Varchar(45) NOT NULL,
    securityQ Varchar(60),
    securityA Varchar(60),
    userType char(2) NOT NULL DEFAULT "U",
  PRIMARY KEY (userId)
);

-- Table userproject
CREATE TABLE userproject (
userId int(11) NOT NULL,
projectId int(11) NOT NULL,
PRIMARY KEY (userId, projectId)
);

/**should fill in createTime values (currently all null)*/
-- Table diagram
CREATE TABLE diagram
(
    diagramId Int(11) NOT NULL AUTO_INCREMENT,
    projectId Int(11) NOT NULL,
    userId Int(11) NOT NULL,
    contextId int(11) NOT NULL,
    diagramType Varchar(45) NOT NULL,
  diagramName Varchar(45) NOT NULL,
    createTime Timestamp,
    filePath Varchar(45) NOT NULL,
    fileType Varchar(20) NOT NULL,
   merged Tinyint NOT NULL DEFAULT 0,
   notationFileName Varchar(45),
   notationFilePath Varchar(45),
   diFlieName Varchar(45),
  diFilepath Varchar(45),
 PRIMARY KEY (diagramId)
);

/**reportfilename should be filled out*/
-- Table report
CREATE TABLE report
(
    reportId Int(11) NOT NULL AUTO_INCREMENT,
    diagramA Int(11) NOT NULL,
   diagramB Int(11) NOT NULL,
   mergedDiagram Int(11),
   type Varchar(20),
   time Timestamp NOT NULL,
   reportFilePath Varchar(200) NOT NULL,
   reportFileName Varchar(45),
  PRIMARY KEY (reportId)
);

-- Table rationale (3/4/2014)
CREATE TABLE rationale
(
    rationaleId int(11) NOT NULL AUTO_INCREMENT,
  compareId int(11) NOT NULL,
  userId int(11) NOT NULL,
  rationaleTime timestamp NOT NULL,
  promotedDiagramId int(11) NOT NULL,
  alternativeDiagramId int(11) NOT NULL,
  summary varchar(255) NOT NULL,
  issue varchar(75),
  issueRelationship varchar(255),
  criteria varchar(75),
  criteriaRelationship varchar(255),
  PRIMARY KEY (rationaleId)
);

-- 2013/10/22 Create Table Policy --
CREATE TABLE policy
(
  policyId INT(11) NOT NULL AUTO_INCREMENT,
  policyName VARCHAR(45) NOT NULL UNIQUE,
  policyDescription VARCHAR(255), 
  policyLevel INT(11) NOT NULL,
  PRIMARY KEY (policyId)
);

-- 2013/10/22 Create Table DiagramContext --
CREATE TABLE diagramContext
(
  diagramContextId Int(11) NOT NULL AUTO_INCREMENT,
  description VARCHAR(255),    
      name VARCHAR(45) NOT NULL,
     policyId INT(11) NOT NULL,
      projectId INT(11) NOT NULL,
      enabled BOOLEAN NOT NULL DEFAULT true,
      disabledDate timestamp,
      PRIMARY KEY (diagramContextId)
);

-- 2013/11/12 Create Table compare --
CREATE TABLE compare
(
  compareId int(11) NOT NULL AUTO_INCREMENT,
  diagramAId int(11) NOT NULL,
  diagramBId int(11) NOT NULL,
  reportId int(11) NOT NULL,
  promoteCountA int(11) DEFAULT 0,
      promoteCountB int(11) DEFAULT 0,
  PRIMARY KEY (compareId)
);

/*Create Relationships*/

ALTER TABLE diagram ADD CONSTRAINT diagramHaveOwnerId FOREIGN KEY (userId) REFERENCES user (userId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE diagram ADD CONSTRAINT diagramHaveProjectId FOREIGN KEY (projectId) REFERENCES project (projectId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE report ADD CONSTRAINT reportHaveDiagramA FOREIGN KEY (diagramA) REFERENCES diagram (diagramId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE report ADD CONSTRAINT reportHaveDiagramB FOREIGN KEY (diagramB) REFERENCES diagram (diagramId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE report ADD CONSTRAINT reportHaveMergedDiagram FOREIGN KEY (mergedDiagram) REFERENCES diagram (diagramId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE rationale ADD CONSTRAINT rationaleHaveCompareId FOREIGN KEY (compareId) REFERENCES compare (compareId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE rationale ADD CONSTRAINT rationaleHaveUserId FOREIGN KEY (userId) REFERENCES user (userId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE rationale ADD CONSTRAINT rationaleHavePromotedDiagramId FOREIGN KEY (promotedDiagramId) REFERENCES diagram (diagramId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE rationale ADD CONSTRAINT rationaleHaveAlternativeDiagramId FOREIGN KEY (alternativeDiagramId) REFERENCES diagram (diagramId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE userproject ADD CONSTRAINT userprojectHaveUserId FOREIGN KEY (userId) REFERENCES user (userId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE userproject ADD CONSTRAINT userprojectHaveProjectId FOREIGN KEY (projectId) REFERENCES project (projectId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE comment ADD CONSTRAINT commentHaveCompareId FOREIGN KEY (compareId) REFERENCES compare (compareId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE comment ADD CONSTRAINT commentHaveUserId FOREIGN KEY (userId) REFERENCES user (userId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE compare ADD CONSTRAINT compareHaveReportId FOREIGN KEY (reportId) REFERENCES report (reportId) ON DELETE NO ACTION ON UPDATE NO ACTION; 
ALTER TABLE compare ADD CONSTRAINT compareHaveDiagramAId FOREIGN KEY (diagramAId) REFERENCES diagram (diagramId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE compare ADD CONSTRAINT compareHaveDiagramBId FOREIGN KEY (diagramBId) REFERENCES diagram (diagramId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE diagramPolicyScore ADD CONSTRAINT diagramPolicyScoreHavePolicyId FOREIGN KEY (policyId) REFERENCES policy (policyId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE diagramPolicyScore ADD CONSTRAINT diagramPolicyScoreHaveDiagramId FOREIGN KEY (diagramId) REFERENCES diagram (diagramId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE diagramContext ADD CONSTRAINT diagramContextHavePolicyId FOREIGN KEY (policyId) REFERENCES policy (policyId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE diagramContext ADD CONSTRAINT diagramContextHaveProjectId FOREIGN KEY (projectId) REFERENCES project (projectId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE diagram ADD CONSTRAINT diagramHaveDiagramContextId FOREIGN KEY (contextId) REFERENCES diagramContext (diagramcontextId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE metric ADD CONSTRAINT metricHavePolicyId FOREIGN KEY (policyId) REFERENCES policy (policyId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE metric ADD CONSTRAINT metricHaveMetricTypeId FOREIGN KEY (metricTypeId) REFERENCES metricType (metricTypeId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE diagramMetricsScore ADD CONSTRAINT diagramMetricsScoreHaveDiagramId FOREIGN KEY (diagramId) REFERENCES diagram (diagramId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE diagramMetricsScore ADD CONSTRAINT diagramMetricsScoreHaveMetricId FOREIGN KEY (metricId) REFERENCES metric (metricId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE attributes ADD CONSTRAINT attributesHaveMetricId FOREIGN KEY (metricId) REFERENCES metric (metricId) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE classes ADD CONSTRAINT classesHaveMetricId FOREIGN KEY (metricId) REFERENCES metric (metricId) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*insert sample data*/
insert into policy (policyName,policyDescription,policyLevel) values ("policy 1","policy 1 description",2);
INSERT INTO policy (policyName, policyDescription, policyLevel) VALUES ('Policy2', 'Policy Description', 2);
INSERT INTO metricType (metricTypeId, description, metricTypeName) VALUES (1, 'ASSOCIATIONS', 'ASSOCIATIONS');
INSERT INTO metricType (metricTypeId, description, metricTypeName) VALUES (2, 'MULTIPLICITIES', 'MULTIPLICITIES');
INSERT INTO metricType (metricTypeId, description, metricTypeName) VALUES (3, 'ATTRIBUTES', 'ATTRIBUTES');
INSERT INTO metricType (metricTypeId, description, metricTypeName) VALUES (4, 'CLASSES', 'CLASSES');
INSERT INTO metric (metricId, policyId, metricTypeID, metricsWeight) VALUES (1, 2, 4, 10);
INSERT INTO metric (metricId, policyId, metricTypeID, metricsWeight) VALUES (2, 2, 3, 10);
INSERT INTO classes (metricId, idealNoOfClasses, maxNoOfClasses, minNOOfClasses) VALUES (1, 4, 5, 2);
INSERT INTO attributes (metricId, idealNoOfAttributes, maxNoOfAttributes, minNOOfAttributes) VALUES (2, 4, 5, 1);




