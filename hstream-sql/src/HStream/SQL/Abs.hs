-- Haskell data types for the abstract syntax.
-- Generated by the BNF converter.

{-# LANGUAGE DeriveFunctor              #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module HStream.SQL.Abs where

import qualified Data.String
import qualified Data.Text
import           Prelude     (Double, Integer, String)
import qualified Prelude     as C (Eq, Functor, Ord, Read, Show)

newtype Ident = Ident Data.Text.Text
  deriving (C.Eq, C.Ord, C.Show, C.Read, Data.String.IsString)

data SQL a
    = QSelect a (Select a)
    | QCreate a (Create a)
    | QInsert a (Insert a)
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data Create a
    = DCreate a Ident [StreamOption a]
    | CreateAs a Ident (Select a) [StreamOption a]
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data StreamOption a
    = OptionFormat a String
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data Insert a = DInsert a Ident [Ident] [ValueExpr a]
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data Select a
    = DSelect a (Sel a) (From a) (Where a) (GroupBy a) (Having a)
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data Sel a = DSel a (SelList a)
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data SelList a
    = SelListAsterisk a | SelListSublist a [DerivedCol a]
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data DerivedCol a
    = DerivedColSimpl a (ValueExpr a)
    | DerivedColAs a (ValueExpr a) Ident
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data From a = DFrom a [TableRef a]
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data TableRef a
    = TableRefSimple a Ident
    | TableRefAs a (TableRef a) Ident
    | TableRefJoin a (TableRef a) (JoinType a) (TableRef a) (JoinWindow a) (JoinCond a)
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data JoinType a
    = JoinInner a | JoinLeft a | JoinOuter a
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data JoinWindow a = DJoinWindow a (Interval a)
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data JoinCond a = DJoinCond a (SearchCond a)
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data Where a = DWhereEmpty a | DWhere a (SearchCond a)
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data GroupBy a = DGroupByEmpty a | DGroupBy a [GrpItem a]
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data GrpItem a = GrpItemCol a (ColName a) | GrpItemWin a (Window a)
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data Window a
    = TumblingWindow a (Interval a)
    | HoppingWindow a (Interval a) (Interval a)
    | SessionWindow a (Interval a)
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data Having a = DHavingEmpty a | DHaving a (SearchCond a)
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data ValueExpr a
    = ExprAdd a (ValueExpr a) (ValueExpr a)
    | ExprSub a (ValueExpr a) (ValueExpr a)
    | ExprMul a (ValueExpr a) (ValueExpr a)
    | ExprInt a Integer
    | ExprNum a Double
    | ExprString a String
    | ExprDate a (Date a)
    | ExprTime a (Time a)
    | ExprInterval a (Interval a)
    | ExprArr a [ValueExpr a]
    | ExprMap a [LabelledValueExpr a]
    | ExprColName a (ColName a)
    | ExprSetFunc a (SetFunc a)
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data Date a = DDate a Integer Integer Integer
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data Time a = DTime a Integer Integer Integer
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data TimeUnit a
    = TimeUnitYear a
    | TimeUnitMonth a
    | TimeUnitWeek a
    | TimeUnitDay a
    | TimeUnitMin a
    | TimeUnitSec a
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data Interval a = DInterval a Integer (TimeUnit a)
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data LabelledValueExpr a = DLabelledValueExpr a Ident (ValueExpr a)
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data ColName a
    = ColNameSimple a Ident
    | ColNameStream a Ident Ident
    | ColNameInner a (ColName a) Ident
    | ColNameIndex a (ColName a) Integer
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data SetFunc a
    = SetFuncCountAll a
    | SetFuncCount a (ValueExpr a)
    | SetFuncAvg a (ValueExpr a)
    | SetFuncSum a (ValueExpr a)
    | SetFuncMax a (ValueExpr a)
    | SetFuncMin a (ValueExpr a)
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data SearchCond a
    = CondOr a (SearchCond a) (SearchCond a)
    | CondAnd a (SearchCond a) (SearchCond a)
    | CondNot a (SearchCond a)
    | CondOp a (ValueExpr a) (CompOp a) (ValueExpr a)
    | CondBetween a (ValueExpr a) (ValueExpr a) (ValueExpr a)
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)

data CompOp a
    = CompOpEQ a
    | CompOpNE a
    | CompOpLT a
    | CompOpGT a
    | CompOpLEQ a
    | CompOpGEQ a
  deriving (C.Eq, C.Ord, C.Show, C.Read, C.Functor)
